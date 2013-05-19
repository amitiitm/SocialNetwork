class AddIsPaidToCredits < ActiveRecord::Migration
  def self.up
    add_column :credits, :is_paid, :boolean, :default => 0
  end

  def self.down
    remove_column :credits, :is_paid
  end
end
