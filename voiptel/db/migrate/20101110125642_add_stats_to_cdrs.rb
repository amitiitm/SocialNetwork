class AddStatsToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :account_stats, :boolean, :default => false
    add_column :cdrs, :ap_stats, :boolean, :default => false
  end

  def self.down
    remove_column :cdrs, :ap_stats
    remove_column :cdrs, :account_stats
  end
end
