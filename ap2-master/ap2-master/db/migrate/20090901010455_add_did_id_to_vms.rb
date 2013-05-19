class AddDidIdToVms < ActiveRecord::Migration
  def self.up
    add_column :vms, :did_id, :integer
  end

  def self.down
    remove_column :vms, :did_id
  end
end
