class CreateAliases < ActiveRecord::Migration
  def self.up
    create_table :aliases do |t|
      t.string :email
      t.string :destination
      t.boolean :enabled
      t.integer :domain_id

      t.timestamps
    end
  end

  def self.down
    drop_table :aliases
  end
end
