class File::ResultsController < ApplicationController
  wrap_parameters false

  def create
    results = JSON.parse(request.body.read)
    show = Show.find_by(id: results.dig('show', 'foreign_id'))
    if show.nil?
      render json: { errors: ['This show must been imported via equipe-ffe in order to export it'] }, status: :unprocessable_entity
    else
      begin
        content = ResultFile.new(show, results).to_xml
        render xml: content
      rescue ResultFile::ClubNotFound => e
        render json: { errors: [e.message] }, status: :unprocessable_entity
      end
    end
  end

end
