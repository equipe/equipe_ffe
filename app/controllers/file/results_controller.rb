class File::ResultsController < ApplicationController
  wrap_parameters false

  def create
    results = JSON.parse(request.body.read)
    # TODO Implement conversion
    Rails.logger.info "GOT #{results.inspect}"
    # render json: results
    render json: { 'errors' => ['This does not work, meaningful error message'] }, status: :unprocessable_entity
  end

end