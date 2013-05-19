class CreatePosInvoices < ActiveRecord::Migration
  def self.up
    create_table :pos_invoices do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_no, :limit=>18	
      t.string    :trans_bk,  :limit=>4	
      t.datetime  :trans_date, :expiry_date
      t.string    :account_period_code, :limit=>8
      t.string    :promo_code, :company_store_code,:limit=>25
      t.integer   :cashier_id, :assosiate_id, :customer_id
      t.string    :comments, :limit=>50
      t.decimal   :discount_per, :precision=>6, :scale=>2, :default=>0
      t.decimal   :tax_per, :precision=>6, :scale=>3, :default=>0
      t.decimal   :item_amt, :discount_amt, :tax_amt, :shipping_amt, :net_amt, :precision=>10, :scale=>2, :default=>0
    end
    add_index :pos_invoices, :pos_invoice_id, :name => "pos_invoices_id" 
  end

  def self.down
    drop_table :pos_invoices
  end
end
