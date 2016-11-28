class AddDetailsToCompetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :competitions, :result_details, :json
  end
end
