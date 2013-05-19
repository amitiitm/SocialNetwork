class DropNotificationsAndNotificationTypesTable < ActiveRecord::Migration
  def self.up
    drop_table  :notifications
    drop_table  :notification_types
  end

  def self.down
  end
end
