class AddConsumedToCards < ActiveRecord::Migration
  def self.up
    add_column :cards, :consumed, :boolean, :default => false
  end

  def self.down
    remove_column :cards, :consumed
  end
end
