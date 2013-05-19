class AlterCrmLeadsAddFields < ActiveRecord::Migration
  def self.up
    add_column :crm_leads, :lead_date, :datetime
  end

  def self.down
    remove_column :crm_leads, :lead_date
  end
end

                   