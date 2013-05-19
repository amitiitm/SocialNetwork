class AddTryToRoutes < ActiveRecord::Migration
  def self.up
    add_column :routes, :try, :integer, :default => 1
  end

  def self.down
    remove_column :routes, :try
  end
end
