class CreateCardCdrs < ActiveRecord::Migration
  def self.up
    create_table :card_cdrs do |t|
      t.integer :did_id
      t.integer :card_id
      t.integer :tmp_phone_id
      t.string :country_id, :limit => 3
      t.string :src, :limit => 80
      t.string :dst_number, :limit => 80
      t.integer :duration
      t.string :disposition, :limit => 45
      t.string :uniqueid, :limit => 32
      t.string :session_log
      t.integer :carrier_id
      t.integer :zone_id
      t.decimal :buy_rate, :precision => 10, :scale => 8
      t.decimal :sell_rate, :precision => 10, :scale => 8
      t.decimal :buy_cost, :precision => 10, :scale => 8
      t.decimal :sell_cost, :precision => 10, :scale => 8
      t.decimal :profit, :precision => 10, :scale => 8
      t.boolean :used_easy_dialer
      t.boolean :easy_dial_number, :limit => 6
      t.integer :digits
      t.string :user_input
      t.integer :input_time
      t.boolean :valid_destination
      t.datetime :date
      t.integer :distributor_id
    end
  end

  def self.down
    drop_table :card_cdrs
  end
end
