class CreateMeltingTransactionActivities < ActiveRecord::Migration
  def self.up
    create_table  :melting_transaction_activities do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :melting_transaction_id
      t.string    :trans_bk,      :limit => 4  , :null => false
      t.string    :trans_no,      :limit => 18 , :null => false
      t.timestamp :trans_date
      t.timestamp :activity_date
      t.string    :melting_stage_code,   :limit => 50
      t.string    :remarks,  :limit =>100
    end
  end

  def self.down
    drop_table :melting_transaction_activities
  end
end