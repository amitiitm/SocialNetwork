class AddReferredMadeDeposit < ActiveRecord::Migration
  def self.up
    add_column :referrals, :referred_made_deposit, :boolean, :default => false
  end

  def self.down
    remove_column :referrals, :referred_made_deposit
  end
end
