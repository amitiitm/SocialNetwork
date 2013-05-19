class AddDefaultCompanyIdFieldToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :default_company_id, :integer
    remove_column :users, :store_id
  end

  def self.down
    remove_column :users, :default_company_id
    add_column :users, :store_id, :integer
  end
end
