class AddIndexesToCdrs < ActiveRecord::Migration
  def self.up
    #add_index :cdrs, :date
    #add_index :cdrs, :disposition
    remove_index :cdrs, :traffic_type
  end

  def self.down
    #remove_index :cdrs, :disposition
    #remove_index :cdrs, :date
    add_index :cdrs, :traffic_type
  end
end
