class Shows::ResultsController < ApplicationController

  def index
    show = Show.find(params[:show_id])
    render xml: ResultFile.new(show)
  end

end