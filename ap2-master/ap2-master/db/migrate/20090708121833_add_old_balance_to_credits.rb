class AddOldBalanceToCredits < ActiveRecord::Migration
  def self.up
    add_column :credits, :old_balance, :decimal, :precision => 12, :scale => 4
  end

  def self.down
    remove_column :credits, :old_balance
  end
end
