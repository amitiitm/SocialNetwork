class AlterCustomersAddCustomerType < ActiveRecord::Migration
  def self.up
    add_column :customers, :customer_type, :string ,:limit=>1, :default=>'W' # 'W' wholesale, 'R' retail
    add_column :customers, :web_access_flag, :string ,:limit=>1, :default=>'N' # 'Y' Allowed, 'N' Not Allowed.
  end

  def self.down
    remove_column :customers, :customer_type
    remove_column :customers, :web_access_flag
  end
end
