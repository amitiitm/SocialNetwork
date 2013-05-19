class AddCreditAppliedToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :credit_applied, :boolean, :default => false
  end

  def self.down
    remove_column :referrals, :credit_applied
  end
end
