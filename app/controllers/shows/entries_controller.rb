class Shows::EntriesController < ApplicationController

  def index
    show = Show.find(params[:show_id])
    entries = Equipe::Entries.new(show)
    render json: entries.as_json
  end

end