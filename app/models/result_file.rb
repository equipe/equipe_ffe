# frozen_string_literal: true
class ResultFile
  def initialize(show, results = {})
    @show = show
    @results = results
  end

  def to_xml(*)
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.message('xmlns:ffe' => 'http://www.ffe.com/message', 'version' => '1.1') do
        xml.info 'logiciel' => 'Equipe', 'version' => '5.0.0'
        xml.concours 'num' => show.ffe_id do
          results['competitions'].pluck('id', 'foreign_id').each do |equipe_competition_id, competition_id|
            competition = Competition.find_by(id: competition_id)
            result_competition = result_competitions[equipe_competition_id]
            if competition
              xml.epreuve num: competition.competition_no, profil_detail: competition.profil_detail do
                starts = results['starts'].select { |start| start['competition_id'] == equipe_competition_id }
                starts.each do |start|
                  entry = Entry.find_by(id: start['foreign_id'])
                  engagement_attributes = {}
                  if entry
                    engagement_attributes['id'] = entry.ffe_id
                    engagement_attributes['dossard'] = entry.start_no
                  else
                    engagement_attributes['terrain'] = true
                  end
                  xml.engagement engagement_attributes do
                    if entry&.rider&.licence != result_riders.dig(start['rider_id'], 'license')
                      cavalier_attributes = {}
                      cavalier_attributes[:lic] = result_riders.dig(start['rider_id'], 'license')
                      cavalier_attributes[:changement] = true if entry.present?
                      xml.cavalier cavalier_attributes
                    end
                    if entry&.horse&.licence != result_horses.dig(start['horse_id'], 'license')
                      equide_attributes = {}
                      equide_attributes[:sire] = result_horses.dig(start['horse_id'], 'license')
                      equide_attributes[:changement] = true if entry.present?
                      xml.equide equide_attributes
                    end
                    club = Club.find_by(id: result_clubs.dig(result_riders.dig(start['rider_id'], 'club_id'), 'foreign_id'))
                    if entry&.rider&.club&.ffe_id != club.ffe_id
                      xml.club num: club.ffe_id
                    end
                    write_results competition, start, xml
                  end
                end
                write_result_details competition, result_competition, xml
              end
            end
          end
        end
      end
    end
    builder.doc.root.name = "ffe:message"
    builder.to_xml
  end

  private

  attr_reader :show, :results

  DISCIPLINE = {
    'D' => 'dressage',
    'H' => 'show_jumping'
  }

  JUDGE_BY = {
    'E' => 5,
    'H' => 3,
    'C' => 1,
    'M' => 2,
    'B' => 4
  }

  # <xsd:restriction base="xsd:string">
  #     <xsd:enumeration value="EL" />
  #     <xsd:enumeration value="AB" />
  #     <xsd:enumeration value="NP" />
  #     <xsd:enumeration value="DISQ" />
  #     <xsd:enumeration value="DISQJU" />
  # </xsd:restriction>

  # app.equipe.com
  # reason:
  #   A: No Start
  #   U: Abandon
  #   D: Éliminé
  #   S: Disqualifié

  FFE_STATUS = {
    'WD' => 'NP',
    'RET' => 'AB',
    'EL' => 'EL',
    'SUSP' => 'DISQ'
  }

  def result_detail_writer(competition)
    :"write_result_#{DISCIPLINE[competition.discipline]}_details"
  end

  def write_result_details(competition, result_competition, xml)
    send result_detail_writer(competition), competition, result_competition, xml
  end

  def writer(competition)
    :"write_#{DISCIPLINE[competition.discipline]}_results"
  end

  def write_results(competition, start, xml)
    send writer(competition), competition, start, xml
  end

  def write_results(competition, start, xml)
    send writer(competition), competition, start, xml
  end

  def write__results(competition, start, xml)
    raise NotImplementedError, "Write result for competition #{competition.id} not implemented"
  end

  def write_dressage_results(competition, start, xml)
    dressage_total = start['results'].detect { |result| result['type'] == 'dressage_total' }
    xml.resultat 'note' => format_percent(dressage_total && dressage_total['percent']) do
      xml.detail do
        xml.manche 'num' => 1 do
          start['results'].reverse.each do |result|
            case result['type']
            when 'dressage'
              xml.score 'num' => JUDGE_BY[result['judge_by']], 'score' => format_percent(result['percent'])
            when 'dressage_total'
              xml.score 'num' => 6, 'score' => format_percent(result['percent'])
            end
          end
        end
      end
    end
  end

  # <engagement id="169484901 00018" dossard="3">
  #   <resultat classement="22">
  #     <detail>
  #       <manche num="1">
  #         <score num="1" score="43.12"/>
  #         <score num="2" score="0.00"/>
  #         <score num="3" score="56.09"/>
  #         <score num="4" score="4.00"/>
  #         <score num="5" score="20"/>
  #         <score num="6" score="24.00"/>
  #       </manche>
  #     </detail>
  #   </resultat>
  # </engagement>


  # <engagement id="169484901 00009" dossard="9">
  #   <resultat etat="EL">
  #     <detail>
  #       <manche num="1" etat="EL"/>
  #     </detail>
  #   </resultat>
  # </engagement>

  def write_show_jumping_results(competition, start, xml)
    start_attributes = {}
    if start['status'].present?
      start_attributes['etat'] = FFE_STATUS['WD']
    elsif start.dig('results', 0, 'status').present?
      start_attributes['etat'] = FFE_STATUS[start.dig('results', 0, 'status')]
    else
      start_attributes['classement'] = start['rank']
    end
    xml.resultat start_attributes do
      xml.detail do
        competition.result_details['starts'].each do |manche|
          if competition.result_details['starts'].one?
            status = start['results'].detect { |result| result['status'].present? }&.dig('status')
          else
            status = start['results'].detect { |result| result['round_no'] == manche['num'].to_i }&.dig('status')
          end
          status = 'WD' if status.blank? && start['status'].present?
          manche_attributes = {}
          manche_attributes['num'] = manche['num']
          manche_attributes['etat'] = FFE_STATUS[status] if status.present?
          xml.manche manche_attributes do
            manche['scores'].each do |score|
              value = case score['nom']
              when 'Temps'
                start['results'].detect { |result| result['round_no'] == manche['num'].to_i }&.dig('time')
              when 'Pénalités de Temps'
                start['results'].detect { |result| result['round_no'] == manche['num'].to_i }&.dig('time_faults')
              when 'Temps 1re phase'
                start['results'].detect { |result| result['round_no'] == 1 }&.dig('time')
              when 'Pénalités de Temps 1re phase'
                start['results'].detect { |result| result['round_no'] == 1 }&.dig('time_faults')
              when 'Temps 2e phase'
                start['results'].detect { |result| result['round_no'] == 2 }&.dig('time')
              when 'Pénalités de Temps 2e phase'
                start['results'].detect { |result| result['round_no'] == 2 }&.dig('time_faults')
              when 'Points sur la piste'
                if competition.result_details['starts'].one?
                  start['results'].select { |result| result['type'] == 'show_jumping' }.map { |result| result['fence_faults'] }.compact.sum
                else
                  raise "Don't know how to get #{score['nom']} profile #{competition.profil_detail}"
                end
              when 'Total Pénalités'
                start['results'].detect { |result| result['type'] == 'show_jumping_total' }&.dig('faults')
              when 'Total pénalités'
                start['results'].detect { |result| result['round_no'] == manche['num'].to_i }&.dig('faults')
              else
                binding.pry if competition.profil_detail.to_i == 3
                raise "Don't know how to get #{score['nom']} profile #{competition.profil_detail}"
              end
              if status.blank?
                xml.score num: score['num'], score: value
              end
            end
          end

        end
      end
    end
  end


  # <resultat>
  #   <detail>
  #     <manche num="1">
  #       <score num="1" score="62"/>
  #       <score num="3" score="43"/>
  #     </manche>
  #   </detail>
  # </resultat>
  def write_result_show_jumping_details(competition, result_competition, xml)
    xml.resultat do
      xml.detail do
        competition.result_details['competitions'].each do |manche|
          xml.manche num: manche['num'] do
            manche['scores'].each do |score|
              value = case score['nom']
              when 'Temps accordé 1re phase'
                max_time_for(result_competition, 1)
              when 'Temps accordé 2e phase'
                max_time_for(result_competition, 2)
              when 'Temps accordé'
                max_time_for(result_competition, manche['num'].to_i)
              else
                raise "Don't know how to get #{score['nom']}"
              end
              xml.score num: score['num'], score: value
            end
          end
        end
      end
    end
  end

  def result_riders
    @result_riders ||= results['people'].index_by { |attrs| attrs['id'] }
  end

  def result_clubs
    @result_clubs ||= results['clubs'].index_by { |attrs| attrs['id'] }
  end

  def result_horses
    @result_horses ||= results['horses'].index_by { |attrs| attrs['id'] }
  end

  def result_competitions
    @result_competitions ||= results['competitions'].index_by { |attrs| attrs['id'] }
  end

  def max_time_for(result_competition, round_no)
    result_competition.dig('judgement', 'rounds').detect { |attrs| attrs['round_no'] == round_no }&.dig('max_time').to_i
  end

  def format_percent(value)
    format('%.3f', value) if value && value.present?
  end
end
