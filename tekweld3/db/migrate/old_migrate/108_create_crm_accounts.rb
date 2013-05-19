class CreateCrmAccounts < ActiveRecord::Migration
  def self.up
    create_table :crm_accounts do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :parent_account_id, :crm_account_category_id ,:primary_contact_id
      t.string    :relationship_type,:address_type, :business_territory,:industry, :ownership_type, :preferred_contact_method,
                  :limit=>50
      t.string    :prefered_contact_time,:prefered_contact_day,  :limit=>50
      t.string    :name , :account_number, :address_name, :address1, :address2, :phone, :fax, :email, 
                  :website, :limit=> 50
      t.string    :city,:state, :limit=>25 , :default=>''
      t.string    :zip, :limit=>15 , :default=>''
      t.string    :country, :limit=>20 , :default=>''
      t.string    :ship_via_code, :term_code, :limit=>25 , :default=>''
      t.decimal   :annual_revenue, :credit_limit,  :precision=>12, :scale=>2, :default=>0
      t.integer   :no_of_employees,   :default=>0
      t.string    :description, :limit=>100
      t.string    :credit_hold_flag, :allow_email, :allow_phone_call, :allow_fax, :allow_mail, 
                  :send_marketing_material,:limit=>1
                
    end
  end

  def self.down
    drop_table :crm_accounts
  end
end
