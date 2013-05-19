class AddMemoIdToMemoUpdates < ActiveRecord::Migration
  def self.up
    add_column :memo_updates, :memo_id, :integer
  end

  def self.down
    remove_column :memo_updates, :memo_id
  end
end
