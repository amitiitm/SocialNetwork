class CreateCarrierTrunks < ActiveRecord::Migration
  def self.up
    create_table :carrier_trunks do |t|
      t.integer :carrier_id
      t.integer :trunk_id

      t.timestamps
    end
    
    add_index :carrier_trunks, :carrier_id
    add_index :carrier_trunks, :trunk_id
  end

  def self.down
    remove_index :carrier_trunks, :trunk_id
    remove_index :carrier_trunks, :carrier_id

    drop_table :carrier_trunks
  end
end
