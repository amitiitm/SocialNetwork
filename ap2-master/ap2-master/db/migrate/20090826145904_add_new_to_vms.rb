class AddNewToVms < ActiveRecord::Migration
  def self.up
    add_column :vms, :new, :boolean, :default => true
  end

  def self.down
    remove_column :vms, :new
  end
end
