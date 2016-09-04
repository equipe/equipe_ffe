class ResultsController < ApplicationController

  def create
    results = JSON.parse(request.body)
    Rails.logger.info "GOT #{results.inspect}"
    head :created
  end

end