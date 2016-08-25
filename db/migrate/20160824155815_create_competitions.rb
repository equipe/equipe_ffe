class CreateCompetitions < ActiveRecord::Migration[5.0]
  def change
    create_table :competitions do |t|
      t.references :show, foreign_key: true, index: true
      t.date :starts_on, null: false
      t.string :competition_no, unique: true
      t.string :name
      t.string :discipline
      t.string :judgement_id

      t.timestamps
    end
  end
end
