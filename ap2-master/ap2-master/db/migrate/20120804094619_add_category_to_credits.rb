class AddCategoryToCredits < ActiveRecord::Migration
  def self.up
    add_column :credits, :category, :integer
  end

  def self.down
    remove_column :credits, :category
  end
end
