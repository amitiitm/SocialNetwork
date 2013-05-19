class AddThresholdAndRechargeAmountToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :threshold, :integer, :default => 0
    add_column :accounts, :recharge_amount, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :recharge_amount
    remove_column :accounts, :threshold
  end
end
