class CreateCrmAddresses < ActiveRecord::Migration
  def self.up
    create_table :crm_addresses do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :address_for_flag, :limit=>1
      t.integer   :address_for_id
      t.string    :address_name, :address1, :address2, :phone, :fax, :email, :address_contact, :limit=> 50
      t.string    :city,:state, :limit=>25 , :default=>''
      t.string    :zip, :limit=>15 , :default=>''
      t.string    :country, :limit=>20 , :default=>''
    end
  end

  def self.down
    drop_table :crm_addresses
  end
end
