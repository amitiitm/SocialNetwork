class AddNotifiedToVms < ActiveRecord::Migration
  def self.up
    add_column :vms, :notified, :boolean, :default => false
  end

  def self.down
    remove_column :vms, :notified
  end
end
