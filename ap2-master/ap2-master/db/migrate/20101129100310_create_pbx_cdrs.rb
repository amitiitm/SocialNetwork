class CreatePbxCdrs < ActiveRecord::Migration
  def self.up
    create_table :pbx_cdrs do |t|
      t.string :dst_number, :limit => 20
      t.integer :admin_user_id
      t.integer :duration
      t.string :disposition, :limit => 14
      t.integer :memo_id
      t.datetime :date
      t.string :cid, :limit => 50
      t.string :contactable_type, :limit => 10
      t.integer :contactable_id
      t.string :uid, :limit => 40
    end
  end

  def self.down
    drop_table :pbx_cdrs
  end
end
