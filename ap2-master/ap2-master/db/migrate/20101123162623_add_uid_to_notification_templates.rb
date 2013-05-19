class AddUidToNotificationTemplates < ActiveRecord::Migration
  def self.up
    add_column :notification_templates, :uid, :string, :limit => 50
    add_index :notification_templates, :uid, :unique => true
  end

  def self.down
    remove_index :notification_templates, :column => :uid
    remove_column :notification_templates, :uid
  end
end