class CreateCustomerInvoices < ActiveRecord::Migration
  def self.up
    create_table :customer_invoices do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :limit=>4
      t.string    :trans_no, :limit=>18
      t.datetime  :trans_date, :inv_date, :due_date, :discount_date, :sale_date
      t.string    :account_period_code, :limit=>25
      t.string    :post_flag, :action_flag, :clear_flag, :limit=>1
      t.string    :trans_type, :limit=>1
      t.string    :inv_type, :limit=>4
      t.string    :inv_no, :limit=>18
      t.integer   :customer_id, :soldto_id, :parent_id
      t.string    :term_code, :salesperson_code, :limit=>25
      t.decimal   :inv_amt, :discount_amt, :paid_amt, :disctaken_amt, :balance_amt, :clear_amt,
                  :item_qty, :precision=>12, :scale=>2
      t.decimal   :discount_per, :precision=>6, :scale=>2
      t.string    :description, :limit=>50
      
    end
  end

  def self.down
    drop_table :customer_invoices
  end
end
