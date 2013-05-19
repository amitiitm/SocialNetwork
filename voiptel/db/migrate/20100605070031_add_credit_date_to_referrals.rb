class AddCreditDateToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :credit_date, :datetime
  end

  def self.down
    remove_column :referrals, :credit_date
  end
end
