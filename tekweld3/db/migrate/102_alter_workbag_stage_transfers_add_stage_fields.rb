class AlterWorkbagStageTransfersAddStageFields < ActiveRecord::Migration
  def self.up
    add_column :workbag_stage_transfers, :stage_to, :string ,:limit=>25
    remove_column :workbag_stage_transfers, :stage_from
    drop_table :pos_order_trackings
    
  end

  def self.down
    remove_column :workbag_stage_transfers, :stage_to
    add_column :workbag_stage_transfers, :stage_from, :string ,:limit=>25
  end
end

