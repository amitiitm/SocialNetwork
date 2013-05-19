class CreateCachedApDeposits < ActiveRecord::Migration
  def self.up
    create_table :cached_ap_deposits do |t|
      t.date :month
      t.decimal :amount
      t.integer :number_of_deposits

      t.timestamps
    end
  end

  def self.down
    drop_table :cached_ap_deposits
  end
end
