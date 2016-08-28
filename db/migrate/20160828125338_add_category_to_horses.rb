class AddCategoryToHorses < ActiveRecord::Migration[5.0]
  def change
    add_column :horses, :category, :string, default: 'H', null: false
  end
end
