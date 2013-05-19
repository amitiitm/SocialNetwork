class AddOwnerToDefaultUis < ActiveRecord::Migration
  def self.up
    add_column :default_uis, :owner, :string
  end

  def self.down
    remove_column :default_uis, :owner
  end
end
