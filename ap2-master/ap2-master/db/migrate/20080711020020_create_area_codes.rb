class CreateAreaCodes < ActiveRecord::Migration
  def self.up
    create_table :area_codes do |t|
      t.string :area_code
      t.integer :country_id
      t.timestamps
    end
  end

  def self.down
    drop_table :area_codes
  end
end
