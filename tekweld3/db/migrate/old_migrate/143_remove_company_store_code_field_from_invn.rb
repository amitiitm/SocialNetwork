class RemoveCompanyStoreCodeFieldFromInvn < ActiveRecord::Migration
  def self.up
    remove_column :inventory_summaries, :company_store_code
    remove_column :inventory_details, :company_store_code
  end

  def self.down
    add_column :inventory_summaries, :company_store_code, :string, :limit=>25
    add_column :inventory_details, :company_store_code, :string, :limit=>25
  end
end
