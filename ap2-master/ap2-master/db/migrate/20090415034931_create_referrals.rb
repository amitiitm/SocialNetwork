class CreateReferrals < ActiveRecord::Migration
  def self.up
    create_table :referrals do |t|
      t.string :referral_first_name
      t.string :referral_last_name
      t.string :phone_number
      t.integer :account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :referrals
  end
end
