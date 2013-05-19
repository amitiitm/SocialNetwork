class RemoveNpanxxFromPhones < ActiveRecord::Migration
  def self.up
    remove_column :phones, :npanxx_id
  end

  def self.down
    add_column :phones, :npanxx_id, :integer
  end
end
