class CreatePosInvoiceAddresses < ActiveRecord::Migration
  def self.up
    create_table :pos_invoice_addresses do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :pos_invoice_id
      t.string    :ship_contact1,:ship_address1,:ship_address2,:ship_phone1,:ship_fax1,  :limit=>50 , :default=>''
      t.string    :ship_city,:ship_state, :limit=>25 , :default=>''
      t.string    :ship_zip, :limit=>15 , :default=>''
      t.string    :ship_country, :limit=>20 , :default=>''
      t.string    :ship_via_code, :limit=>25 , :default=>''
      t.datetime  :ship_date
      t.string    :tracking_no, :limit=>50     
      t.string    :bill_contact1,:bill_address1,:bill_address2,:bill_phone1,:bill_fax1, :limit=>50 , :default=>''
      t.string    :bill_city,:bill_state,:limit=>25 , :default=>''
      t.string    :bill_zip, :limit=>15 , :default=>''
      t.string    :bill_country, :limit=>20 , :default=>''
      
    
      
    end
  end

  def self.down
    drop_table :pos_invoice_addresses
  end
end
