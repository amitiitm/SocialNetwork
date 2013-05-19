class AddPriorityToRoutes < ActiveRecord::Migration
  def self.up
    add_column :routes, :priority, :integer
  end

  def self.down
    remove_column :routes, :priority
  end
end
