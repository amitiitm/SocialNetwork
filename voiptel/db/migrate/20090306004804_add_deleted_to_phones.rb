class AddDeletedToPhones < ActiveRecord::Migration
  def self.up
    add_column :phones, :deleted, :boolean, :default => false
  end

  def self.down
    remove_column :phones, :deleted
  end
end
