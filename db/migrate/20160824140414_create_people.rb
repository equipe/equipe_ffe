class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :licence, index: true, unique: true
      t.date :birthday
      t.boolean :official, null: false, default: false
      t.references :club, foreign_key: true
      t.references :region, foreign_key: true
      t.timestamps
    end
  end
end
