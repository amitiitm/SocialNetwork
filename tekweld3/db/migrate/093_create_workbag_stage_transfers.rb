class CreateWorkbagStageTransfers < ActiveRecord::Migration
  def self.up
    create_table :workbag_stage_transfers do |t|
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
      t.string    :trans_type,   :limit => 1
      t.string    :account_period_code,    :limit => 8 , :null => false
      t.string    :ext_ref_no, :limit =>50
      t.timestamp :ext_ref_date
      t.string    :stage_from,:limit =>25
      t.string    :workbag_flag,:limit =>1
      t.string    :remarks,:limit =>255
    end
  end

  def self.down
    drop_table :workbag_stage_transfers
  end
end
