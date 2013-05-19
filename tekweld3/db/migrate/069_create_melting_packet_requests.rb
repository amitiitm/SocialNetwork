class CreateMeltingPacketRequests < ActiveRecord::Migration
  def self.up
    create_table :melting_packet_requests do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :trans_bk,      :limit => 4  , :null => false
      t.string    :trans_no,      :limit => 18 , :null => false
      t.timestamp :trans_date
      t.string    :account_period_code,    :limit => 8 , :null => false
      t.string    :status,      :limit => 6 , :null => false
      t.string    :customer_ref_no,                 :limit => 25 
      t.timestamp :customer_ref_date
      t.string    :customer_name,                :limit => 50,                                 :default => ""
      t.string    :customer_address1,            :limit => 50,                                 :default => ""
      t.string    :customer_address2,            :limit => 50,                                 :default => ""
      t.string    :customer_city,                :limit => 25,                                 :default => ""
      t.string    :customer_state,               :limit => 25,                                 :default => ""
      t.string    :customer_zip,                 :limit => 15,                                 :default => ""
      t.string    :customer_country,             :limit => 20,                                 :default => ""
      t.string    :customer_email_id ,            :limit => 50
      t.string    :customer_phone,               :limit => 50,                                 :default => ""
      t.string    :customer_fax,                 :limit => 50,                                 :default => ""
      t.string    :remarks, :limit=>255
    end
  end

  def self.down
    drop_table :melting_packet_requests
  end
end
