class CreateCrmContacts < ActiveRecord::Migration
  def self.up
    create_table :crm_contacts do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :crm_account_id
      t.string    :salutation ,  :limit=>4
      t.string    :first_name, :last_name, :job_title,:department, :manager, :spouse_name, :limit=>50     
      t.string    :address_name, :address1, :address2, :business_phone, :manager_phone, :home_phone, :cell_phone, :fax, :email, :limit=> 50
      t.string    :city,:state, :limit=>25 , :default=>''
      t.string    :zip, :limit=>15 , :default=>''
      t.string    :country, :limit=>20 , :default=>''
      t.string    :address_type, :role, :preferred_contact_method, :limit=>50
      t.string    :gender, :marital_status, :limit=>15
      t.datetime  :date_of_birth, :date_of_marraige
      t.decimal   :credit_limit,  :precision=>12, :scale=>2, :default=>0
      t.string    :credit_hold_flag, :allow_email, :allow_phone_call, :allow_fax, :allow_mail, 
                  :send_marketing_material,:limit=>1
      t.string    :prefered_contact_time,:prefered_contact_day, :prefered_contact, :limit=>50
      
    end
  end

  def self.down
    drop_table :crm_contacts
  end
end
