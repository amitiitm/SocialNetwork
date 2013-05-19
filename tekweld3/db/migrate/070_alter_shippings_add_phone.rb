class AlterShippingsAddPhone < ActiveRecord::Migration
  def self.up
    add_column :shippings, :phone, :string, :limit=>50
  end

  def self.down
    remove_column :shippings, :phone
  end
end
