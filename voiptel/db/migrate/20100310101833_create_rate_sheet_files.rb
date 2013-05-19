class CreateRateSheetFiles < ActiveRecord::Migration
  def self.up
    create_table :rate_sheet_files do |t|
      t.integer :rate_sheet_id
      t.integer :my_file_id

      t.timestamps
    end
    add_index :rate_sheet_files, :rate_sheet_id
    add_index :rate_sheet_files, :my_file_id
  end

  def self.down
    remove_index :rate_sheet_files, :my
    remove_index :rate_sheet_files, :rate_sheet_id
    drop_table :rate_sheet_files
  end
end
