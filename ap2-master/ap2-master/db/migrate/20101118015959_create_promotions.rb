class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
      t.string :name, :limit => 50
      t.integer :days
      t.string :prefix, :limit => 20
      t.decimal :rate, :precision => 5, :scale => 4
      t.string :country_id, :limit => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :promotions
  end
end