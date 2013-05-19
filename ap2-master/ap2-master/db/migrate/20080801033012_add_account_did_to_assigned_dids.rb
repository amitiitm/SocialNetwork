class AddAccountDidToAssignedDids < ActiveRecord::Migration
  def self.up
    add_column :assigned_dids, :account_did_id, :integer
  end

  def self.down
    remove_column :assigned_dids, :account_did_id
  end
end
