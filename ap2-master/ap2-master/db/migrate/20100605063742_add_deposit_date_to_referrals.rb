class AddDepositDateToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :deposit_date, :datetime
  end

  def self.down
    remove_column :referrals, :deposit_date
  end
end
