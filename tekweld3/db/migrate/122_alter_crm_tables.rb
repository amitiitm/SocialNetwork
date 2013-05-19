class AlterCrmTables < ActiveRecord::Migration
  def self.up
    add_column :crm_tasks, :trans_bk, :string ,:limit=>4
    add_column :crm_tasks, :trans_no, :string ,:limit=>18
    add_column :crm_activities, :trans_bk, :string ,:limit=>4
    add_column :crm_activities, :trans_no, :string ,:limit=>18
    add_column :crm_contacts, :code, :string ,:limit=>25
  end

  def self.down
    remove_column :crm_tasks, :trans_bk
    remove_column :crm_tasks, :trans_no
    remove_column :crm_activities, :trans_bk
    remove_column :crm_activities, :trans_no
    remove_column :crm_contacts, :code
  end
end

