class CreateEmailConfigs < ActiveRecord::Migration
  def self.up
    create_table  :email_configs do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :event_type, :limit=>4,:default=>'AUTO'
      t.string    :trigger_event, :limit=>50 , :null=>false
      t.string    :subject, :limit=>100
      t.string    :email_to, :limit=>500
      t.string    :email_cc, :limit=>500
      t.string    :email_bcc, :limit=>500
      t.string    :email_from, :limit=>50
    end
  end

  def self.down
    drop_table :email_configs
  end
end
