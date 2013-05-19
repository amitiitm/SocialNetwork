class AlterCatalogPrivacyPolicies < ActiveRecord::Migration
  def self.up
    add_column :catalog_private_policies, :diaspark_default, :string, :limit=>1, :default=>'N'
  end

  def self.down
    remove_column :catalog_private_policies, :diaspark_default
  end
end
