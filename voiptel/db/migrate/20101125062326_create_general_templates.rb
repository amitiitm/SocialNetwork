class CreateGeneralTemplates < ActiveRecord::Migration
  def self.up
    create_table :general_templates do |t|
      t.string :name
      t.string :uid
      t.text :template
      t.timestamps
    end
  end

  def self.down
    drop_table :general_templates
  end
end
