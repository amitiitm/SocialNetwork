class CreateCatalogParameters < ActiveRecord::Migration
  def self.up
  create_table :catalog_parameters do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :company_logo_file, :limit=>100
      t.string    :company_short_name, :limit=>50
      t.string    :company_full_name, :limit=>100
      t.string    :online_inquiries, :limit=>100
      t.string    :store_inquires_contact_no, :limit=>50
      t.string    :store_inquires, :limit=>50
      t.string    :personalshopper, :limit=>50
     end
  end

  def self.down
    drop_table :catalog_parameters
  end
end
