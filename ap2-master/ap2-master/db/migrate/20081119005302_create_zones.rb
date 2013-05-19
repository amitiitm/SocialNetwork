class CreateZones < ActiveRecord::Migration
  def self.up
    create_table :zones do |t|
      t.string :name
      t.string :prefix
      t.integer :ztype
      t.decimal :buy_rate  ,:precision => 10, :scale => 8
      t.decimal :sell_rate ,:precision => 10, :scale => 8
      t.integer :country_id

      t.timestamps
    end
  end

  def self.down
    drop_table :zones
  end
end
