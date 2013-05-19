class AlterShippingsAddUrl < ActiveRecord::Migration
  def self.up
    add_column :shippings, :url, :string, :limit=>200
  end

  def self.down
    remove_column :shippings, :url
  end
end
