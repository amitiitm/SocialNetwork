class AddDefaultDateFormatToAdminUsers < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :default_date_format, :string, :limit => 40, :default => "%a %m/%d %H:%M"
  end

  def self.down
    remove_column :admin_users, :default_date_format
  end
end
