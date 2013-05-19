class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
        t.column :company_id, :int, :null=>false
        t.column :created_by, :int
        t.column :created_at, :datetime
        t.column :updated_by, :int
        t.column :updated_at, :datetime
        t.column :trans_flag, :string, :limit=>1,:default=>'A'
        t.column :update_flag, :string, :limit=>1,:default=>'Y'
        t.column :lock_version, :int, :default=>0
        t.column :user_cd, :string, :limit=>25
        t.column :login_type, :string, :limit=>1, :null=>false
        t.column :type_id, :string, :limit=>25, :null=>false
        t.column :category_id, :int
        t.column :login_flag, :string,:limit=>1, :null=>false,:default=>'N'
        t.column :password_change_date, :datetime
        t.column :user_flag, :string,:limit=>1, :default=>'A'
        t.column :login, :string
        t.column :email, :string
        t.column :first_name, :string, :limit => 80 #1
        t.column :last_name, :string, :limit => 80 #2
        t.column :crypted_password, :string, :limit => 40
        t.column :salt, :string, :limit => 40
        t.column :remember_token, :string
        t.column :remember_token_expires_at, :datetime
        t.column :last_moodule_id, :int
        t.column :date_format, :string, :limit => 10
        t.column :total_logins, :int, :default => 0
        t.column :store_id, :int
    end
  end

  def self.down
    drop_table :users
  end
end



