class CreateVendorCategories < ActiveRecord::Migration
  def self.up
    create_table  :vendor_categories do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :code, :limit=>25, :null=>false
      t.string    :name, :limit=>50
      t.decimal   :discount_per, :precision=>6, :scale=>2
      t.string    :invoice_term_code, :limit=>25
      t.string    :memo_term_code, :limit=>25
      t.integer   :gl_account_payable_id, :null=>true
      t.integer   :gl_account_expense_id, :null=>true
      t.integer   :gl_discount_account_id, :null=>true
    end
  end

  def self.down
    drop_table :vendor_categories
  end
end
