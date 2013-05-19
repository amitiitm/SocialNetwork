class CreateDataUploadRequests < ActiveRecord::Migration
  def self.up
    create_table :dataupload_requests do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => 'Y'
      t.string    :trans_flag,   :limit => 1,    :default => 'A'
      t.integer   :lock_version,                 :default => 0
      t.timestamp :request_date
      t.string    :request_email_id, :limit=>100, :null => false
      t.string    :request_file_name, :limit=>100, :null => false
      t.string    :server_file_path, :limit=>200, :null => false
      t.string    :request_status,  :limit => 1,    :default => 'N'  #N for New and P for processed.
      t.string    :response1_flag,  :limit => 1,    :default => 'N'  #N for no response, Y for Response
      t.string    :response2_flag,  :limit => 1,    :default => 'N'  #N for no response, Y for Response 
      t.string    :overwrite_flag,  :limit => 1,    :default => 'N'  #N for no response, Y for Response
    end
  end

  def self.down
    drop_table :dataupload_requests
  end
end
