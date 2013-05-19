class AddSequenceToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :sequence, :integer, :limit => 1, :default => 1
  end

  def self.down
    remove_column :cdrs, :sequence
  end
end
