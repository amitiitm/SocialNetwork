class AddRatecenterToDid < ActiveRecord::Migration
  def self.up
    add_column :dids, :npanxx_id, :integer
  end

  def self.down
    remove_column :dids, :npanxx_id
  end
end
