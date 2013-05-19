class AddFieldsToDistributions < ActiveRecord::Migration
  def self.up
    add_column :distributions, :num_cards, :integer
    add_column :distributions, :sold, :integer, :default => 0
    add_column :distributions, :serial_start, :string
    add_column :distributions, :serial_end, :string    
  end

  def self.down
    remove_column :distributions, :serial_end
    remove_column :distributions, :serial_start
    remove_column :distributions, :sold
    remove_column :distributions, :num_cards
  end
end
