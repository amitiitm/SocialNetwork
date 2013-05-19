class AddEamilsToMemoUpdates < ActiveRecord::Migration
  def self.up
    add_column :memo_updates, :emails, :text
  end

  def self.down
    remove_column :memo_updates, :emails
  end
end
