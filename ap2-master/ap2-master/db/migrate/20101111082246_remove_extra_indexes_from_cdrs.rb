class RemoveExtraIndexesFromCdrs < ActiveRecord::Migration
  def self.up
    remove_index :cdrs, :did_id
    remove_index :cdrs, :zone_id
    remove_index :cdrs, :phone_id
  end
  
  def self.down
    add_index :cdrs, :phone_id
    add_index :cdrs, :zone_id
    add_index :cdrs, :did_id
  end
end
