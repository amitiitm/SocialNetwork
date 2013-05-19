class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table  :emails do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0      
      t.integer   :email_config_id, :null=>false
      t.string    :subject, :limit=>100
      t.string    :email_to, :limit=>500
      t.string    :email_cc, :limit=>500
      t.string    :email_bcc, :limit=>500
      t.string    :email_from, :limit=>50
      t.string    :header
      t.text      :body
      t.datetime  :sent_on
      t.integer   :attempts
    end    
  end

  def self.down
     drop_table :emails
  end
end
