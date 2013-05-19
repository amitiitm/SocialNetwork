class CreateCompanyStores < ActiveRecord::Migration
  def self.up
    create_table :company_stores do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :code,  :limit=>25, :null=>false
      t.string    :name,  :limit=>50
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
    end
  end

  def self.down
    drop_table :company_stores
  end
end
