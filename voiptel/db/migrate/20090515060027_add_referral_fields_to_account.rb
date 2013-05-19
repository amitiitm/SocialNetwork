class AddReferralFieldsToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :number_of_referrals, :integer, :default => 0
  end

  def self.down
    remove_column :accounts, :number_of_referrals
  end
end
