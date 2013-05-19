class CreateServerSettings < ActiveRecord::Migration
  def self.up
    create_table :server_settings do |t|
      t.string :module
      t.integer :server_id
      t.text :settings

      t.timestamps
    end
    add_index :server_settings, :module
    add_index :server_settings, :server_id
  end

  def self.down
    remove_index :server_settings, :server_id
    remove_index :server_settings, :module
    mind
    drop_table :server_settings
  end
end
