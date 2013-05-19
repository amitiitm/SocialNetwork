class CreateCarrierEndpoints < ActiveRecord::Migration
  def self.up
    create_table :carrier_endpoints do |t|
      t.integer :carrier_id
      t.integer :endpoint_id
      
      t.timestamps
    end
    add_index :carrier_endpoints, :carrier_id
    add_index :carrier_endpoints, :endpoint_id
  end

  def self.down
    remove_index :carrier_endpoints, :endpoint_id
    remove_index :carrier_endpoints, :carrier_id
    drop_table :carrier_endpoints
  end
end
