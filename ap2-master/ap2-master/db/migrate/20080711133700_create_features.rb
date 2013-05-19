class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.string :subject
      t.text :body
      t.integer :priority
      t.integer :url_id

      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
