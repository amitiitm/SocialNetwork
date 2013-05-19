class CreateAttachments < ActiveRecord::Migration
 def self.up
      create_table :attachments do |t| 
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :table_name,  :limit=>30
      t.integer   :trans_id
      t.integer   :user_id, :null=>false
      t.datetime  :date_added
      t.string    :subject,  :limit=>100
      t.string    :notes,  :limit=>500
      t.string    :file_name,  :limit=>500, :null=>false
      t.string    :folder_name,   :limit=>500, :null=>false
      end
  end

  def self.down
     drop_table :attachments
  end
end
