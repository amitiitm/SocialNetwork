class RemoveDefaultStoreCodeFieldFromCompanies < ActiveRecord::Migration
  def self.up
    remove_column :companies, :default_store_id
    remove_column :companies, :default_store_code
  end

  def self.down
    add_column :companies, :default_store_id, :integer
    add_column :companies, :default_store_code, :string, :limit=>25
  end
end
