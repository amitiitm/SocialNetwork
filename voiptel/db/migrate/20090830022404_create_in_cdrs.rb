class CreateInCdrs < ActiveRecord::Migration
  def self.up
    create_table :in_cdrs do |t|
      t.integer :did_id
      t.integer :user_id
      t.string :cid
      t.string :cname
      t.integer :duration
      t.datetime :date

      t.timestamps
    end
  end

  def self.down
    drop_table :in_cdrs
  end
end
