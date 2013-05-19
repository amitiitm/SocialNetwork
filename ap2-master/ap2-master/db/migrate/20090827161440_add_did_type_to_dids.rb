class AddDidTypeToDids < ActiveRecord::Migration
  def self.up
    add_column :dids, :did_type, :integer, :default => 1
  end

  def self.down
    remove_column :dids, :did_type
  end
end
