class RemoveUriFromVmBoxes < ActiveRecord::Migration
  def self.up
    remove_column :vm_boxes, :uri
  end

  def self.down
    add_column :vm_boxes, :uri, :string
  end
end
