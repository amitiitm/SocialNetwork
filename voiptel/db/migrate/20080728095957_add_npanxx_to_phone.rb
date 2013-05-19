class AddNpanxxToPhone < ActiveRecord::Migration
  def self.up
    add_column :phones, :npanxx_id, :integer
  end

  def self.down
    remove_column :phones, :npanxx_id
  end
end
