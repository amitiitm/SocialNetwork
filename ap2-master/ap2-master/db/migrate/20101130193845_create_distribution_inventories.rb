class CreateDistributionInventories < ActiveRecord::Migration
  def self.up
    create_table :distribution_inventories do |t|
      t.integer :distribution_id
      t.string :serial_start
      t.string :serial_end
      t.integer :cards_start
      t.integer :cards_end
      t.integer :num_cards

      t.timestamps
    end
  end

  def self.down
    drop_table :distribution_inventories
  end
end
