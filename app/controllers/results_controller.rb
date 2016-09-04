class ResultsController < ApplicationController
  wrap_parameters false

  def create
    results = JSON.parse(request.body.read)
    Rails.logger.info "GOT #{results.inspect}"
    head :accepted
  end

end