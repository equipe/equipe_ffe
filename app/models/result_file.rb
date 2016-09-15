# frozen_string_literal: true
class ResultFile
  def initialize(show, results = {})
    @show = show
    @results = results
  end

  def to_xml(*)
    builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.message('xmlns:ffe' => 'http://www.ffe.com/message', 'version' => '1.1') do
        xml.info 'logiciel' => 'Tests', 'version' => '0.0.0'
        xml.concours 'num' => show.ffe_id do
          results['competitions'].pluck('id', 'foreign_id').each do |equipe_competition_id, competition_id|
            competition = Competition.find(competition_id)
            starts = results['starts'].select { |start| start['competition_id'] == equipe_competition_id }
            starts.each do |start|
              entry = Entry.find_by(id: start['foreign_id'])
              xml.engagement 'id' => entry&.ffe_id, 'dossard' => start['start_no'] do
                write_results competition, start, xml
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

  def writer(competition)
    :"write_#{DISCIPLINE[competition.discipline]}_results"
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
              binding.pry
              xml.score 'num' => 6, 'score' => format_percent(result['percent'])
            end
          end
        end
      end
    end
  end

  def format_percent(value)
    format('%.3f', value) if value && value.present?
  end
end