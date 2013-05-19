class AddVmStuffToSubscriber < ActiveRecord::Migration
  def self.up
    add_column :subscriber, :timeout, :integer, :default => 20
    add_column :subscriber, :vm_enabled, :boolean, :default => true
  end

  def self.down
    remove_column :subscriber, :vm_enabled
    remove_column :subscriber, :timeout
  end
end
