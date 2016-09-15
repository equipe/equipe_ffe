# frozen_string_literal: true
class ResultFile
  def initialize(show, results = {})
    @show = show
    @results = results
  end

  def to_xml(options = {})
    builder = Nokogiri::XML::Builder.new(options) do |xml|
      xml['ffe'].message('xmlns:ffe' => 'http://www.ffe.com/message', 'version' => '1.1') do
        xml.info 'logiciel' => 'Tests', 'version' => '0.0.0'
        xml.concours 'num' => show.ffe_id
        results['competitions'].pluck('id', 'foreign_id').each do |equipe_competition_id, competition_id|
          competition = Competition.find(competition_id)
          starts = results['starts'].select { |start| start['competition_id'] == equipe_competition_id }
          starts.each do |start|
            entry = Entry.find_by(id: start['foreign_id'])
            xml.engagement 'id' => entry.ffe_id, 'dossard' => start['start_no'] do
            end
          end
        end
      end
    end
    builder.to_xml
  end

  private

  attr_reader :show, :results
end