class CreateIvrCategories < ActiveRecord::Migration
  def self.up
    create_table :ivr_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :ivr_categories
  end
end
