class ChangeRateCenterToRateCenterIdFromNpanxx < ActiveRecord::Migration
  def self.up
    remove_column :npanxxes, :rate_center
    add_column :npanxxes, :rate_center_id, :integer
  end

  def self.down
    add_column :npanxxes, :rate_center, :integer
    remove_column :npanxxes, :rate_center_id
  end
end
