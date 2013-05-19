class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :company_cd, :limit=>25, :null=>false
      t.string    :name, :limit=>50
      t.string    :address1,:limit=>50
      t.string    :address2,:limit=>50
      t.string    :city, :limit=>25
      t.string    :state, :limit=>25
      t.string    :zip, :limit=>15
      t.string    :phone, :limit=>50
      t.string    :fax, :limit=>50
      t.string    :remarks,  :limit=>50
      t.string    :aboutus,  :limit=>1000
      t.integer   :default_store_id
      t.string    :default_store_code, :limit=>25, :null=>true
    end
  end

  def self.down
    drop_table :companies
  end
end
