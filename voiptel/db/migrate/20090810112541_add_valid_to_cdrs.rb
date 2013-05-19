class AddValidToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :valid_destination, :boolean
  end

  def self.down
    remove_column :cdrs, :valid_destination
  end
end
