class File::ResultsController < ApplicationController
  wrap_parameters false

  def create
    results = JSON.parse(request.body.read)
    show = Show.find(results.dig('show', 'foreign_id'))
    render xml: ResultFile.new(show, results)
  end

end