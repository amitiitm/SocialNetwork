class AddMappedToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :mapped, :boolean, :default => false
  end

  def self.down
    remove_column :referrals, :mapped
  end
end
