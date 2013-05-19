class AlterPosOrdersAddWorkbagFields < ActiveRecord::Migration
  def self.up
    add_column :pos_orders, :wb_trans_id, :integer
    add_column :pos_orders, :wb_trans_bk, :string ,:limit=>4 
    add_column :pos_orders, :wb_trans_no, :string ,:limit=>18
    add_column :pos_orders, :wb_trans_date, :datetime
  end

  def self.down
    remove_column :pos_orders, :wb_trans_id
    remove_column :pos_orders, :wb_trans_bk
    remove_column :pos_orders, :wb_trans_no
    remove_column :pos_orders, :wb_trans_date
  end
end

