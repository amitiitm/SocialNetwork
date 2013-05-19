class AddShortNameToCarriers < ActiveRecord::Migration
  def self.up
    add_column :carriers, :short_name, :string
    add_index :carriers, :short_name, :unique => true
  end

  def self.down
    remove_index :carriers, :column => :short_name
    remove_column :carriers, :short_name
  end
end
