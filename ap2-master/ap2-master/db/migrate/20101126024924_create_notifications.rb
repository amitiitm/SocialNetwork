class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.text :content
      t.string :subject, :limit => 50
      t.string :from_name, :limit => 50
      t.string :from_address, :limit => 50
      t.string :to_name, :limit => 50
      t.string :to_address, :limit => 50
      t.integer :notification_template_id
      t.integer :notification_category_id
      t.string :emailable_type, :limit => 10
      t.integer :emailable_id
      t.integer :memo_id
      t.boolean :delivered
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
