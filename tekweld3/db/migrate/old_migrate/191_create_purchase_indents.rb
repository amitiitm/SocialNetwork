class CreatePurchaseIndents < ActiveRecord::Migration
  def self.up
    create_table :purchase_indents do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :trans_bk, :ref_trans_bk, :limit=>4, :null=>false
      t.string    :trans_no, :ref_trans_no, :limit=>18, :null=>false
      t.datetime  :trans_date, :null=>false	
      t.string    :account_period_code, :limit=>8, :null=>false
      t.datetime  :indent_date
      t.string    :term_code, :shipping_code, :limit=>25
      t.datetime  :due_date, :ship_date, :ref_trans_date
      t.string    :trans_type, :ref_type, :limit=>1	
      t.string    :post_flag, :limit=>1	, :default=>'U'
      t.decimal   :item_qty, :clear_qty, :precision=>6, :scale=>2, :default=>0
      t.string    :remarks, :limit=>255	
      t.string    :tracking_no, :limit=>50	
      t.string    :ship_name, :ship_address1, :ship_address2, :limit=>50
      t.string    :ship_city, :ship_state, :limit=>25
      t.string    :ship_zip, :limit=>15
      t.string    :ship_country, :limit=>20
      t.string    :ship_phone, :ship_fax, :limit=>50
      t.string    :ext_ref_no, :limit=>50
      t.datetime  :ext_ref_date
      t.string    :purchaseperson_code, :limit=>25
    end
  end

  def self.down
    drop_table :purchase_indents
  end
end
