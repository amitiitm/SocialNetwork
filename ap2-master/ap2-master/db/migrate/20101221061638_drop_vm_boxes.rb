class DropVmBoxes < ActiveRecord::Migration
  def self.up
    drop_table :vm_boxes
  end

  def self.down
  end
end
