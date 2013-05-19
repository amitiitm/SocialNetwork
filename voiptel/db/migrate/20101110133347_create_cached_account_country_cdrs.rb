class CreateCachedAccountCountryCdrs < ActiveRecord::Migration
  def self.up
    create_table :cached_account_country_cdrs do |t|
      t.date :month
      t.integer :account_id
      t.string  :country_id, :limit => 2
      t.integer :duration, :default => 0
      t.integer :calls, :default => 0
      t.integer :answer, :default => 0
      t.integer :busy, :default => 0
      t.integer :cancel, :default => 0
      t.integer :congestion, :default => 0
      t.integer :invalid_num, :integer, :default => 0
      t.integer :no_input, :integer, :default => 0
      t.integer :other_dispositions, :integer, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :cached_account_country_cdrs
  end
end
