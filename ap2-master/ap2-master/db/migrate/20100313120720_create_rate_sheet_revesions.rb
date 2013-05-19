class CreateRateSheetRevesions < ActiveRecord::Migration
  def self.up
    create_table :rate_sheet_revesions do |t|
      t.integer :carrier_id
      t.integer :rate_sheet_id
      t.integer :revesion

      t.timestamps
    end
  end

  def self.down
    drop_table :rate_sheet_revesions
  end
end
