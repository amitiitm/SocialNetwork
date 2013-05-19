class AddSignupTrackinfInfoToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :signed_up_by_type, :string, :default => "", :limit => 10
    add_column :accounts, :signed_up_by_id, :integer
  end

  def self.down
    remove_column :accounts, :signed_up_by_id
    remove_column :accounts, :signed_up_by_type
  end
end
