class CreateMainUsers < ActiveRecord::Migration
  def self.up
     create_table :main_users  do |t|
      t.integer   :main_company_id
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :user_cd, :limit=>50
      t.datetime  :password_change_date
      t.string    :login, :limit => 50 
      t.string    :email, :limit => 50 
      t.string    :first_name, :limit => 80 
      t.string    :last_name, :limit => 80 
      t.string    :crypted_password, :limit => 40
      t.string    :salt, :limit => 40
      t.string    :remember_token
      t.datetime  :remember_token_expires_at
      t.datetime  :last_login
    end
  end

  def self.down
    drop_table :main_users 
  end
end
