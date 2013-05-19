class AddAutoRechargeToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :auto_recharge, :boolean, :default => false
    add_column :accounts, :auto_recharge_amount, :integer
  end

  def self.down
    remove_column :accounts, :auto_recharge_amount
    remove_column :accounts, :auto_recharge
  end
end
