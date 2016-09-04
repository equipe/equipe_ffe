class File::ResultsController < ApplicationController

  def create
    results = JSON.parse(request.body)
    # TODO Implement conversion
    Rails.logger.info "GOT #{results.inspect}"
    render json: results
  end

end