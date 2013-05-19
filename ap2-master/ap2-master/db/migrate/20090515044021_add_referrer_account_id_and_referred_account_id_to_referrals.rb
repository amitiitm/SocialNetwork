class AddReferrerAccountIdAndReferredAccountIdToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :referrer_account_id, :integer
  end

  def self.down
    remove_column :referrals, :referrer_account_id
  end
end
