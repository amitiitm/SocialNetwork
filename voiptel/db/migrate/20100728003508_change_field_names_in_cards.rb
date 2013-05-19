class ChangeFieldNamesInCards < ActiveRecord::Migration
  def self.up
    rename_column :cards, :enabled, :used
    add_column :cards, :used_date, :datetime
  end

  def self.down  
    remove_column :cards, :used_date
    rename_column :cards, :used, :enabled
  end
end
