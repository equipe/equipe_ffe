class CreateShows < ActiveRecord::Migration[5.0]
  def change
    create_table :shows do |t|
      t.references :organizer, foreign_key: true
      t.string :ffe_id, index: true, unique: true
      t.string :name
      t.date :starts_on
      t.date :ends_on

      t.timestamps
    end
  end
end
