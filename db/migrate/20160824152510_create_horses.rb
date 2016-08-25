class CreateHorses < ActiveRecord::Migration[5.0]
  def change
    create_table :horses do |t|
      t.string :licence, index: true, unique: true
      t.string :chip_no
      t.string :name
      t.string :sire
      t.string :dam
      t.string :dam_sire
      t.integer :born_year
      t.string :color
      t.string :breed
      t.string :race
      t.integer :height
      t.string :sex
      t.timestamps
    end
  end
end
