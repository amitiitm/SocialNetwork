class AddShortNameToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :short_name, :string
  end

  def self.down
    remove_column :servers, :short_name
  end
end
