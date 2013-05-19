class AddRateCenterAndLatAandLatLongToDids < ActiveRecord::Migration
  def self.up
    add_column :dids, :rate_center, :string, :limit => 25
    add_column :dids, :lata, :integer
    add_column :dids, :lat, :decimal, :precision => 9, :scale => 5
    add_column :dids, :long, :decimal, :precision => 9, :scale => 5
  end

  def self.down
    remove_column :dids, :long
    remove_column :dids, :lat
    remove_column :dids, :lata
    remove_column :dids, :rate_center    
  end
end
