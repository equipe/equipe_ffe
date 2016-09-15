class File::ResultsController < ApplicationController
  wrap_parameters false

  def create
    results = JSON.parse(request.body.read)
    show = Show.find_by(id: results.dig('show', 'foreign_id'))
    if show.nil?
      render json: { errors: ['This show must been imported via equipe-ffe in order to export it'] }, status: :unprocessable_entity
    else
      render xml: ResultFile.new(show, results)
    end
  end

end