class CreateRateSheets < ActiveRecord::Migration
  def self.up
    create_table :rate_sheets do |t|
      t.string :name
      t.string :effective_date
      t.boolean :active, :default => false
      t.integer :carrier_id

      t.timestamps
    end
    add_index :rate_sheets, :carrier_id
  end

  def self.down
    remove_index :rate_sheets, :carrier_id
    drop_table :rate_sheets
  end
end
