class AddSequenceToCardCdrs < ActiveRecord::Migration
  def self.up
    add_column :card_cdrs, :sequence, :integer, :limit => 1, :default => 1;
  end

  def self.down
    remove_column :card_cdrs, :sequence
  end
end
