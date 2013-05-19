class CreateInventoryTransfers < ActiveRecord::Migration
  def self.up
    create_table :inventory_transfers do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.datetime  :transfer_date
      t.integer   :store_id_from, :store_id_to, :null=>false
      t.string    :issued_trans_bk, :received_trans_bk, :limit=>4
      t.string    :issued_trans_no, :received_trans_no, :limit=>18
      t.datetime  :issued_trans_date, :received_trans_date
      t.string    :issued_serial_no, :received_serial_no, :limit=>6
      t.string    :account_period_code, :limit=>8
      t.integer   :catalog_item_id, :null=>false
      t.string    :catalog_item_code, :limit=>25, :null=>false
      t.decimal   :transfer_qty, :precision=>10, :scale=>2, :default=>0
      t.decimal   :transfer_price, :transfer_amt, :precision=>12, :scale=>2, :default=>0
      t.string    :status, :limit=>1, :default=>'T' #'T' means in-transit
    end
  end

  def self.down
    drop_table :inventory_transfers
  end
end
