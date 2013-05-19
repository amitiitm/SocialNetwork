class CreateCdrs < ActiveRecord::Migration
  def self.up
    create_table :cdrs do |t|      
      t.integer :did_id
      t.integer :account_id
      t.integer :user_id
      t.integer :phone_id
      t.integer :dst_country_id
      t.string :src, :limit => 80
      t.string :dst_number, :limit => 80
      t.string :src_channel, :limit => 80
      t.string :dst_channel, :limit => 80
      t.integer :duration
      t.string :disposition, :limit => 45
      t.string :uniqueid, :limit => 32
      t.datetime :date
    end
  end

  def self.down
    drop_table :cdrs
  end
end
