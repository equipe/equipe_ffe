class AddHorsePonyToCompetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :competitions, :horse_pony, :string, null: false, default: 'R'
  end
end
