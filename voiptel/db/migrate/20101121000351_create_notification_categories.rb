class CreateNotificationCategories < ActiveRecord::Migration
  def self.up
    create_table :notification_categories do |t|
      t.string :name, :limit => 50

      t.timestamps
    end
  end

  def self.down
    drop_table :notification_categories
  end
end
