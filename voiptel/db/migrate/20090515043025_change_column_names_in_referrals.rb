class ChangeColumnNamesInReferrals < ActiveRecord::Migration
  def self.up
    rename_column :referrals, :referral_first_name, :referrer_first_name
    rename_column :referrals, :referral_last_name, :referrer_last_name
    rename_column :referrals, :phone_number, :referrer_phone_number
    rename_column :referrals, :account_id, :referred_account_id
  end

  def self.down
    rename_column :referrals, :referrer_last_name, :referrer_last_name
    rename_column :referrals, :referrer_first_name, :referral_first_name
    rename_column :referrals, :referrer_phone_number, :phone_number
    rename_column :referrals, :referred_account_id, :account_id
  end
end
