class CreateCachedApDailyCountryCdrs < ActiveRecord::Migration
  def self.up
    create_table :cached_ap_daily_country_cdrs do |t|
      t.date     "day"
      t.string   "country_id",         :limit => 2
      t.integer  "duration",                                                       :default => 0
      t.integer  "calls",                                                          :default => 0
      t.integer  "answer",                                                         :default => 0
      t.integer  "busy",                                                           :default => 0
      t.integer  "cancel",                                                         :default => 0
      t.integer  "congestion",                                                     :default => 0
      t.integer  "invalid_num",                                                    :default => 0
      t.integer  "other_dispositions",                                             :default => 0
      t.decimal  "buy_cost",                        :precision => 10, :scale => 4, :default => 0.0
      t.decimal  "sell_cost",                       :precision => 10, :scale => 4, :default => 0.0
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def self.down
    drop_table :cached_ap_daily_country_cdrs
  end
end
