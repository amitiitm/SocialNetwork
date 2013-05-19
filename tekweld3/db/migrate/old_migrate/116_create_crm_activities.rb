class CreateCrmActivities < ActiveRecord::Migration
  def self.up
    create_table :crm_activities do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.datetime  :trans_date, :due_date
      t.integer   :performed_user_id, :crm_account_id,:crm_contact_id,:crm_task_id, :crm_opportunity_id
      t.string    :subject,		:limit=>50
      t.string    :description, :limit=>100
    end
  end

  def self.down
    drop_table :crm_activities
  end
end
