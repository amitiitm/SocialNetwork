# YA ALI
class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.string :prefix            , :length => 40
      t.integer :prefix_length    
      t.string :desc              , :length => 100
      t.string :carrier_desc      , :length => 100
      t.decimal :buy              ,:precision => 10, :scale => 8
      t.decimal :sell             ,:precision => 10, :scale => 8
      t.integer :rate_group_id
      t.integer :rate_sheet_id
      t.integer :trunk_id
      t.integer :carrier_id
      t.integer :country_id
      t.boolean :custom           , :default => false
      t.integer :freq             , :default => 0
      t.boolean :publish          , :default => false
      t.integer :priority         , :default => 0
      t.boolean :cli              , :default => false
      t.integer :quality          , :default => 0
      t.integer :status           , :default => 0
      t.decimal :diff             , :precision => 10, :scale => 8
      t.integer :phone_type       , :default => 0

      t.timestamps
    end
    add_index :rates, :prefix
    add_index :rates, :country_id
    add_index :rates, :carrier_id  
  end

  def self.down
    drop_table :rates
  end
end
