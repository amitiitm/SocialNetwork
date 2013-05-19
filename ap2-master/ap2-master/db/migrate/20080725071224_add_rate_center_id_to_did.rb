class AddRateCenterIdToDid < ActiveRecord::Migration
  def self.up
    add_column :dids, :rate_center_id, :integer
  end

  def self.down
    remove_column :dids, :rate_center_id
  end
end
