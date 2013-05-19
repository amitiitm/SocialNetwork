class AddSubjectAndFromNamesToNotificationTemplates < ActiveRecord::Migration
  def self.up
    add_column :notification_templates, :subject, :string, :limit => 50
    add_column :notification_templates, :from_name, :string, :limit => 50
    add_column :notification_templates, :from_address, :string, :limit => 50
  end

  def self.down
    remove_column :notification_templates, :from_address
    remove_column :notification_templates, :from_name
    remove_column :notification_templates, :subject
  end
end
