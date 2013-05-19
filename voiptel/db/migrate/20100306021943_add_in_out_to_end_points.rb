class AddInOutToEndPoints < ActiveRecord::Migration
  def self.up
    add_column :endpoints, :in, :boolean, :default => false
    add_column :endpoints, :out, :boolean, :default => false
  end

  def self.down
    remove_column :endpoints, :out
    remove_column :endpoints, :in
  end
end
