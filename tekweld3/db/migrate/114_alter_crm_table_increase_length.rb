class AlterCrmTableIncreaseLength < ActiveRecord::Migration
  def self.up
    change_column :crm_opportunities, :description ,:string ,:limit=>200
    change_column :crm_activities, :description ,:string ,:limit=>200
  end

  def self.down
    change_column :crm_opportunities, :description ,:string ,:limit=>100
    change_column :crm_activities, :description ,:string ,:limit=>100
  end
end

                   