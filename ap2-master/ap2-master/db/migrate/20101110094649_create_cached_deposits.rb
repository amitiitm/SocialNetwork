class CreateCachedDeposits < ActiveRecord::Migration
  def self.up
    create_table :cached_deposits do |t|
      t.date :month
      t.decimal :amount, :precision => 10, :scale => 2, :default => 0
      t.integer :account_id            
      t.timestamps      
    end
  end

  def self.down
    drop_table :cached_deposits
  end
end
