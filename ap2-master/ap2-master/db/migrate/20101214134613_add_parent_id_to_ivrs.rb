class AddParentIdToIvrs < ActiveRecord::Migration
  def self.up
    add_column :ivrs, :parent_id, :integer
  end

  def self.down
    remove_column :ivrs, :parent_id
  end
end
