class CreatePurchasepeople < ActiveRecord::Migration
  def self.up
    create_table :purchasepeople do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :code, :limit=>25, :null=>false
      t.string    :name, :address1, :address2, :phone1, :fax1,:contact1, :limit=>50
      t.string    :city, :state,  :limit=>25
      t.string    :zip,  :limit=>15
      t.string    :country,  :limit=>20
    end
  end

  def self.down
     drop_table :purchasepeople
  end
end
