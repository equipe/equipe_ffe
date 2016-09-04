class File::EntriesController < ApplicationController
  wrap_parameters false

  def create
    entry_file = EntryFile.new(request.body)
    if entry_file.valid?
      entry_file.import
      entries = Equipe::Entries.new(entry_file.show)
      render json: entries.as_json
    else
      head :unprocessable_entity
    end
  end
end
