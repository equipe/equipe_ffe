class CreateClubs < ActiveRecord::Migration[5.0]
  def change
    create_table :clubs do |t|
      t.string :ffe_id, index: true, unique: true
      t.string :name

      t.timestamps
    end
  end
end
