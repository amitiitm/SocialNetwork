class CreateCrmTasks < ActiveRecord::Migration
  def self.up
    create_table :crm_tasks do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.datetime  :trans_date, :due_date, :end_date, :start_date, :reminder_datetime
      t.integer   :crm_account_id, :assigned_user_id, :crm_contact_id, :duration
      t.string    :description, :limit=>100
      t.string    :subject,:status, :priority,:location, :limit=>50
      t.string    :reminder_flag, :limit=>1
    end
  end

  def self.down
    drop_table :crm_tasks
  end
end
