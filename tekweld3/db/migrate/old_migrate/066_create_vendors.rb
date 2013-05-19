class CreateVendors < ActiveRecord::Migration
  def self.up
    create_table :vendors do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :code, :limit=>25, :null=>false
      t.string    :first_name, :limit=>50 , :default=>''
      t.string    :last_name, :limit=>50 , :default=>''
      t.string    :name, :limit=>100 , :default=>''
      t.integer   :vendor_category_id, :null=>false
      t.string    :invoice_term_code, :limit=>25
      t.string    :memo_term_code, :purchaseperson_code, :limit=>25
      t.decimal   :credit_limit, :precision=>12, :scale=>2 
      t.string    :price_level, :limit=>1 ,:default=>'A'
      t.string    :address1, :limit=>50 , :default=>''
      t.string    :address2, :limit=>50 , :default=>''
      t.string    :city, :limit=>25 , :default=>''
      t.string    :state, :limit=>25 , :default=>''
      t.string    :zip, :limit=>15 , :default=>''
      t.string    :country, :limit=>20 , :default=>''
      t.string    :phone, :limit=>50 , :default=>''
      t.string    :fax, :limit=>50 , :default=>''
      t.string    :cell_no, :limit=>15 , :default=>''
      t.string    :email_to, :limit=>200 , :default=>''
      t.string    :email_cc, :limit=>200 , :default=>''
      t.decimal   :discount_per, :precision=>5, :scale=>2 , :default=>0
      t.integer   :gl_account_id
      t.string    :shipping_code, :limit=>25
    end
  end

  def self.down
    drop_table :vendors
  end
end
