class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.string :ffe_id, null: false, unique: true, index: true
      t.references :competition, foreign_key: true
      t.integer :start_no
      t.references :rider, foreign_key: { to_table: :people }
      t.references :horse, foreign_key: true
      t.timestamps
    end
  end
end
