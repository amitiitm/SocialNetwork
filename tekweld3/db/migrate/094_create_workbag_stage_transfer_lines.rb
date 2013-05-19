class CreateWorkbagStageTransferLines < ActiveRecord::Migration
  def self.up
    create_table :workbag_stage_transfer_lines do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :workbag_stage_transfer_id , :null => false
      t.string    :trans_bk,      :limit => 4  , :null => false
      t.string    :trans_no,      :limit => 18 , :null => false
      t.timestamp :trans_date
      t.string    :trans_type,   :limit => 1
      t.string    :account_period_code,    :limit => 8 , :null => false
      t.string    :serial_no,   :limit => 6
      t.integer   :ref_trans_id
      t.string    :ref_trans_bk,      :limit => 4 
      t.string    :ref_trans_no,      :limit => 18 
      t.timestamp :ref_trans_date
      t.string    :ref_type,   :limit => 1
      t.decimal   :ref_qty, :precision=>6, :scale=>2 
      t.string    :item_type,   :limit => 1
      t.integer   :catalog_item_id
      t.string    :catalog_item_code,:limit =>255
      t.string    :catalog_item_description,:limit =>50
      t.integer   :catalog_item_packet_id
      t.string    :catalog_item_packet_code,:limit =>25
      t.string    :from_stage,:limit =>25
      t.string    :to_stage,:limit =>25
      t.decimal   :trans_qty, :precision=>6, :scale=>2 
    end
  end

  def self.down
    drop_table :workbag_stage_transfer_lines
  end
end
