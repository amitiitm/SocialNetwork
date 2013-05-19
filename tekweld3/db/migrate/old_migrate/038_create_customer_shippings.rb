class CreateCustomerShippings < ActiveRecord::Migration
  def self.up
    create_table :customer_shippings do |t|
        t.column :company_id, :int, :null=>false
        t.column :created_by, :int , :default=>0
        t.column :created_at, :datetime
        t.column :updated_by, :int, :default=>0
        t.column :updated_at, :datetime
        t.column :trans_flag, :string,:limit=>1 ,:default=>'A'
        t.column :update_flag, :string,:limit=>1 ,:default=>'A'
        t.column :lock_version, :int, :default=>0
        t.column :code, :string,:limit=>25, :null=>false
        t.column :name, :string,:limit=>50 , :default=>''
        t.column :customer_id, :int, :default=>0
        t.column :serial_no, :string, :limit =>6
        t.column :contact1, :string,:limit=>50 , :default=>''
        t.column :address1, :string,:limit=>50 , :default=>''
        t.column :address2, :string,:limit=>50 , :default=>''
        t.column :city, :string,:limit=>25 , :default=>''
        t.column :state, :string,:limit=>25 , :default=>''
        t.column :zip, :string,:limit=>15 , :default=>''
        t.column :country, :string,:limit=>20 , :default=>''
        t.column :phone1, :string,:limit=>50 , :default=>''
        t.column :fax1, :string,:limit=>50 , :default=>''
        t.column :old_code, :string,:limit=>25 , :default=>''
  end
  end

  def self.down
    drop_table :customer_shippings
  end
  end