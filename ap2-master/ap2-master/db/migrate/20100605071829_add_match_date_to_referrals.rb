class AddMatchDateToReferrals < ActiveRecord::Migration
  def self.up
    add_column :referrals, :match_date, :datetime
  end

  def self.down
    remove_column :referrals, :match_date
  end
end
