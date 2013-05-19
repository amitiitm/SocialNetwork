class CreateDiamondPurchase < ActiveRecord::Migration
  def self.up
    create_table :diamond_purchases do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :limit=>4	
      t.string    :trans_no, :limit=>18
      t.datetime  :trans_date	
      t.integer   :vendor_id, :company_store_id	
      t.string    :account_period_code, :limit=>8
      t.string    :term_code, :purchaseperson_code, :shipping_code, :limit=>25
      t.string    :ref_trans_no, :limit=>18	
      t.string    :trans_type, :post_flag, :ref_type, :limit=>1	
      t.decimal   :ship_per, :insurance_per, :tax_per, :discount_per, :precision=>6, :scale=>2
      t.decimal   :ship_amt, :insurance_amt, :tax_amt, :discount_amt, :precision=>12, :scale=>2
      t.decimal   :lines_amt, :other_amt, :commission_amt, :net_amt, :precision=>12, :scale=>2
      t.decimal   :commission_per, :precision=>6, :scale=>2
      t.string    :ref_trans_bk, :limit=>4	
      t.string    :remarks, :limit=>255	
      t.string    :tracking_no, :po_no, :ship_name, :bill_name, :limit=>50	
      t.datetime  :ref_trans_dt, :po_date, :ship_date, :cancel_date, :due_date	
      t.string    :ship_address1, :ship_address2, :bill_address1, :bill_address2, :limit=>50
      t.string    :ship_city, :ship_state, :bill_city, :bill_state, :limit=>25
      t.string    :ship_zip, :bill_zip, :limit=>15
      t.string    :ship_country, :bill_country, :limit=>20
      t.string    :ship_phone, :ship_fax,:bill_phone, :bill_fax, :limit=>50
      t.decimal   :total_pcs, :precision=>12, :scale=>2
      t.decimal   :total_wt, :precision=>12, :scale=>3
      t.string    :type, :limit=>50	
    end
  end

  def self.down
    drop_table :diamond_purchases
  end
end
