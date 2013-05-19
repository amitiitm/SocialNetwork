class ChangeMemoIdToMemoUpdateIdInNotifications < ActiveRecord::Migration
  def self.up
    rename_column :notifications, :memo_id, :memo_update_id
  end

  def self.down
    #rename_column :notifications, :memo_update_id, :memo_id
  end
end
