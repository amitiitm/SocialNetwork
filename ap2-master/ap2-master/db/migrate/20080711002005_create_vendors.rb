class CreateVendors < ActiveRecord::Migration
  def self.up
    create_table :vendors do |t|
      t.integer :vid
      t.integer :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :vendors
  end
end
