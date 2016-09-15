class AddProfilDetailToCompetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :competitions, :profil_detail, :integer
  end
end
