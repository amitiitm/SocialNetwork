class CreateDiasparkLicenses < ActiveRecord::Migration
  def self.up
    create_table  :diaspark_licenses  do |t|
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :user_id, :null=>false 
      t.string    :code, :limit => 25 ,:null=>false
      t.string    :product_code, :limit => 25 ,:null=>false
      t.string    :free_trial_flag, :limit => 1 
      t.datetime  :from_date, :to_date
      t.integer   :maximum_active_user_allowed
      t.integer   :maximum_active_store_allowed
      t.decimal   :licence_fee_per_month,  :precision => 6,  :scale => 2
      t.string    :autorenewal_flag, :limit => 1 
      t.string    :current_status, :limit => 1 
      t.datetime  :expiry_date
      
    end
  end

  def self.down
    drop_table :diaspark_licenses
  end
end



	