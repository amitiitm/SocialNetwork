class CreateCrmLeads < ActiveRecord::Migration
  def self.up
    create_table :crm_leads do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :topic,       :limit=>100
      t.string    :first_name,  :limit=>50
      t.string    :last_name,  :limit=>50
      t.string    :name,  :limit=>50
      t.integer   :crm_lead_category_id
      t.integer   :account_id 
      t.string    :relationship_type,  :limit=>50
      t.string    :address_type,  :limit=>50
      t.string    :business_territory,  :limit=>50
      t.string    :industry,  :limit=>50
      t.string    :ownership_type,  :limit=>50
      t.string    :lead_number,  :limit=>50
      t.string    :account_number,  :limit=>50
      t.string    :address_name,  :limit=>50
      t.string    :address1,  :limit=>50
      t.string    :address2,  :limit=>50
      t.string    :phone,  :limit=>50
      t.string    :fax,  :limit=>50
      t.string    :email,  :limit=>50
      t.string    :website,  :limit=>50
      t.string    :city,  :limit=>25
      t.string    :state,  :limit=>25
      t.string    :zip,  :limit=>15
      t.string    :country,  :limit=>20
      t.string    :business_phone,  :limit=>50
      t.string    :home_phone,  :limit=>50
      t.string    :other_phone,  :limit=>50
      t.string    :mobile_phone,  :limit=>50
      t.string    :pager,  :limit=>50
      t.string    :lead_source,  :limit=>50
      t.string    :rating,  :limit=>50
      t.string    :job_title,  :limit=>50
      t.string    :saluation,  :limit=>50
      t.decimal   :annual_revenue, :precision=>12, :scale=>2     ,:default=>0.00
      t.string    :description,  :limit=>100
      t.integer   :no_of_employees
      t.timestamp :last_followed_date
      t.timestamp :next_followed_date
    end
  end

  def self.down
    drop_table :crm_leads
  end
end

