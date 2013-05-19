class AddActiveToDids < ActiveRecord::Migration
  def self.up
    add_column :dids, :active, :boolean, :default => true
  end

  def self.down
    remove_column :dids, :active
  end
end
