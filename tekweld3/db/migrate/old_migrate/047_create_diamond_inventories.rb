class CreateDiamondInventories < ActiveRecord::Migration
  def self.up
    create_table :diamond_inventories do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :limit=>4
      t.string    :trans_no, :limit=>18
      t.string    :account_period_code, :limit=>8
      t.datetime  :trans_date	
      t.string    :post_flag, :ri_flag, :limit=>1
      t.string    :remarks, :limit=>255
    end
  end

  def self.down
    drop_table :diamond_inventories
  end
end
