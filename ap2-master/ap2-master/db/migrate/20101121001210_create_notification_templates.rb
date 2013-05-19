class CreateNotificationTemplates < ActiveRecord::Migration
  def self.up
    create_table :notification_templates do |t|
      t.text :template
      t.integer :notification_type_id
      t.integer :notification_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :notification_templates
  end
end
