class AddSubjectToNotificationType < ActiveRecord::Migration
  def self.up
    add_column :notification_types, :subject, :string
  end

  def self.down
    remove_column :notification_types, :subject
  end
end
