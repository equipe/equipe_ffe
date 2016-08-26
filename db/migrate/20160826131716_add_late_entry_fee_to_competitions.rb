class AddLateEntryFeeToCompetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :competitions, :late_entry_fee, :integer
  end
end
