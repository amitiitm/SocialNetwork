class CreateMeltingTransactions < ActiveRecord::Migration
  def self.up
    create_table :melting_transactions do |t|
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
      t.integer   :vendor_id
      t.string    :status,      :limit => 6 , :null => false
      t.string    :current_melting_stage_code,      :limit => 25 
      t.string    :customer_ref_no,                 :limit => 25 
      t.timestamp :customer_ref_date
      t.string    :retailer_ref_no,                 :limit => 25 
      t.timestamp :retailer_ref_date
      t.string    :receive_ship_via,                 :limit => 25 
      t.string    :receive_tracking_no,              :limit => 25 
      t.timestamp :receive_date
      t.string    :sent_ship_via,              :limit => 25 
      t.string    :sent_tracking_no,              :limit => 25 
      t.timestamp :ship_date
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
      t.string    :video_file_name,                 :limit => 50
      t.decimal   :offer_amt,      :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :check_amt,      :precision => 12, :scale => 2, :default => 0.0
      t.timestamp :check_date
      t.string    :check_no,              :limit => 25 
      t.decimal   :commission_amt,           :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :commission_paid_amt,      :precision => 12, :scale => 2, :default => 0.0
      t.timestamp :commission_paid_date
      t.decimal   :gold_rate,             :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :silver_rate,           :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :platinum_rate,         :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :paladdium_rate,        :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :total_pcs,             :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :total_gold_wt,         :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :total_silver_wt,       :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :total_platinum_wt,     :precision => 12, :scale => 2, :default => 0.0
      t.decimal   :total_paladdium_wt,    :precision => 12, :scale => 2, :default => 0.0
      t.timestamp :check_encashed_date
      t.string    :video_recorded_flag,          :limit => 1   
      t.string    :metal_info_updated_flag,      :limit => 1
      t.string    :pre_offer_sent_flag,          :limit => 1
      t.string    :offer_sent_flag,              :limit => 1
      t.string    :accept_reject_flag,           :limit => 1
      t.string    :check_print_flag,             :limit => 1
      t.string    :check_sent_flag,              :limit => 1
      t.string    :check_encashed_flag,          :limit => 1
      t.string    :reminder_sent_flag,           :limit => 1
      t.string    :stop_payment_flag,            :limit => 1
      t.string    :goods_returned_flag,          :limit => 1
      t.string    :video_attached_flag,          :limit => 1
      t.string    :remarks,  :limit =>100
      t.string    :salt,  :limit =>40 ,:null => false
    end
  end

  def self.down
    drop_table :melting_transactions
  end
end