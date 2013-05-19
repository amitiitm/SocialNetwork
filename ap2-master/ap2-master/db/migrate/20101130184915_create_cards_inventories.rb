class CreateCardsInventories < ActiveRecord::Migration
  def self.up
    create_table :cards_inventories do |t|
      t.integer :value
      t.integer :num_cards
      t.integer :cards_start
      t.integer :cards_end
      t.string :serial_start, :limit => 20
      t.string :serial_end, :limit => 20
      t.boolean :allocated, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :cards_inventories
  end
end
