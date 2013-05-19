class CreateWebsiteUsers < ActiveRecord::Migration
  def self.up
    create_table "website_users", :force => true do |t|
      t.integer   "company_id",                :default => 1,   :null => false
      t.integer   "created_by"
      t.timestamp "created_at"
      t.integer   "updated_by"
      t.timestamp "updated_at"
      t.string    "trans_flag",                :limit => 1,  :default => "A"
      t.string    "update_flag",               :limit => 1,  :default => "Y"
      t.integer "lock_version",                            :default => 0
      t.string    "code",                   :limit => 25
      t.string    "email",                     :limit=>100
      t.string    "first_name",                :limit => 100
      t.string    "last_name",                 :limit => 100
      t.string    "address1",                 :limit => 50
      t.string    "address2",                 :limit => 50
      t.string    "business_phone",           :limit => 50
      t.string    "home_phone",               :limit => 50
      t.string    "cell_phone",               :limit => 50
      t.string    "fax",                      :limit => 50
      t.string    "email",                    :limit => 50
      t.string    "city",                     :limit => 25,                                :default => ""
      t.string    "state",                    :limit => 25,                                :default => ""
      t.string    "zip",                      :limit => 15,                                :default => ""
      t.string    "country",                  :limit => 20,                                :default => ""
      t.string    "crypted_password",          :limit => 50
      t.string    "salt",                      :limit => 50
      t.timestamp "password_change_date"
      t.string    "remember_token",            :limit => 1
      t.timestamp "remember_token_expires_at"
      t.string    "date_format",               :limit => 10
      t.integer "total_logins",              :default => 0
    end
  end

  def self.down
    drop_table :website_users
  end
end
