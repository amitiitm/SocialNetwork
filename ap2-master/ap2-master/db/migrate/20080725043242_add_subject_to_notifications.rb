class AddSubjectToNotifications < ActiveRecord::Migration
  def self.up
    add_column :notifications, :subject, :string
  end

  def self.down
    remove_column :notifications, :subject
  end
end
