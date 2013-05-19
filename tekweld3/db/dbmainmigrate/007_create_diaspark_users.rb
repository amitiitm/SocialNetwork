class CreateDiasparkUsers < ActiveRecord::Migration
  def self.up
    create_table :diaspark_users  do |t|
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :first_name, :limit => 80 ,:null=>false
      t.string    :last_name, :limit => 80 ,:null=>false
      t.string    :email, :limit => 50 ,:null=>false
      t.string    :user_name, :limit => 50 ,:null=>false
      t.string    :crypted_password, :limit => 40
      t.string    :company_name, :limit => 80 ,:null=>false
      t.string    :short_name, :limit => 80 ,:null=>false
      t.string    :phone, :limit => 80 ,:null=>false
      t.string    :industry, :limit => 80 ,:null=>false
      t.string    :address1, :limit => 50
      t.string    :address2, :limit => 50 ,:null=>false
      t.string    :city, :limit => 25 ,:null=>false
      t.string    :state, :limit => 25 ,:null=>false
      t.string    :zip, :limit => 15 ,:null=>false
      t.string    :country, :limit => 20 ,:null=>false
      t.string    :salt, :limit => 40
    end
  end

  def self.down
    drop_table :diaspark_users
  end
end

