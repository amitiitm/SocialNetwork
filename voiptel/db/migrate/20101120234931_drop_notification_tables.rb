class DropNotificationTables < ActiveRecord::Migration
  def self.up
    drop_table :notifications
    drop_table :notification_queues
    drop_table :notification_templates
    drop_table :notification_types
  end

  def self.down
  end
end
