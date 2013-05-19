class AddReferrerUserIdToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :referrer_user_id, :integer
  end

  def self.down
    remove_column :referrals, :referrer_user_id
  end
end
