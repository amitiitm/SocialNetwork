class AlterCompaniesAddBusinessCard < ActiveRecord::Migration
   def self.up
    add_column :companies, :business_card, :string, :limit=>100  
  end

  def self.down
    remove_column :companies, :business_card
  end
end
