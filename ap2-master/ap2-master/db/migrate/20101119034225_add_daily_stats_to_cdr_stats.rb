class AddDailyStatsToCdrStats < ActiveRecord::Migration
  def self.up
    add_column :cdr_stats, :account_daily, :boolean, :default => 0
    add_column :cdr_stats, :ap_daily, :boolean, :default => 0
  end

  def self.down
    remove_column :cdr_stats, :ap_daily
    remove_column :cdr_stats, :account_daily
  end
end
