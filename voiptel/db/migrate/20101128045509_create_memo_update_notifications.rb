class CreateMemoUpdateNotifications < ActiveRecord::Migration
  def self.up
    create_table :memo_update_notifications do |t|
      t.integer :memo_update_id
      t.integer :notification_id

      t.timestamps
    end
  end

  def self.down
    drop_table :memo_update_notifications
  end
end
