class CreateTmpTemplates < ActiveRecord::Migration
  def self.up
    create_table :tmp_templates do |t|
      t.text :template
      t.integer :notification_template_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tmp_templates
  end
end
