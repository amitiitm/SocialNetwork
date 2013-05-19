class CreateCachedAccountCdrs < ActiveRecord::Migration
  def self.up
    create_table :cached_account_cdrs do |t|
      t.date :month
      t.integer :account_id
      t.integer :duration, :default => 0
      t.integer :calls, :default => 0
      t.integer :answer, :default => 0
      t.integer :busy, :default => 0
      t.integer :cancel, :default => 0
      t.integer :congestion, :default => 0
      t.decimal :buy_cost, :default => 0, :precision => 10, :scale => 8
      t.decimal :sell_cost, :default => 0, :precision => 10, :scale => 8

      t.timestamps
    end
  end

  def self.down
    drop_table :cached_account_cdrs
  end
end
