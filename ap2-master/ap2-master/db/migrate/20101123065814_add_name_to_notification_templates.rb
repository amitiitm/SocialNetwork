class AddNameToNotificationTemplates < ActiveRecord::Migration
  def self.up
    add_column :notification_templates, :name, :string, :limit => 50
  end

  def self.down
    remove_column :notification_templates, :name
  end
end
