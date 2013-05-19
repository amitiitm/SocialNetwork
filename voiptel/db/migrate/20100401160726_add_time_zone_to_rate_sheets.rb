class AddTimeZoneToRateSheets < ActiveRecord::Migration
  def self.up
    add_column :rate_sheets, :time_zone, :string
  end

  def self.down
    remove_column :rate_sheets, :time_zone
  end
end
