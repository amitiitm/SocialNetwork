class CreateAccountPromotions < ActiveRecord::Migration
  def self.up
    create_table :account_promotions do |t|
      t.integer :account_id
      t.string :name, :limit => 50
      t.string :prefix, :limit => 20
      t.integer :days
      t.decimal :rate, :precision => 5, :scale => 4
      t.boolean :expired, :default => false
      t.string :country_id, :limit => 2
      
      t.timestamps
    end
  end

  def self.down
    drop_table :account_promotions
  end
end
