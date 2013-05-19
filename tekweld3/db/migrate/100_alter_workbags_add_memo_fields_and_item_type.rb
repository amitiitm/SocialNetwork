class AlterWorkbagsAddMemoFieldsAndItemType < ActiveRecord::Migration
  def self.up
    add_column :workbags, :memo_vendor_id, :integer
    add_column :workbags, :vendor_memo_id, :integer 
    add_column :workbags, :item_type , :string ,:limit=>1
    add_column :workbags, :vendor_memo_no , :string ,:limit=>25
    add_column :workbags, :vendor_po_bk  , :string ,:limit=>4
    add_column :workbags, :vendor_memo_bk , :string ,:limit=>4
    add_column :workbags, :wb_type , :string ,:limit=>4
    add_column :workbags, :vendor_memo_date, :datetime
    add_column :workbags, :vendor_memo_qty, :decimal, :precision=>12, :scale=>2
    #two more table
    add_column :pos_orders, :item_type , :string ,:limit=>1
    add_column :pos_orders, :wb_type , :string ,:limit=>4
    add_column :contractor_memos, :item_type , :string ,:limit=>1
  end

  def self.down
    remove_column :workbags, :memo_vendor_id
    remove_column :workbags, :item_type
    remove_column :workbags, :wb_type
    remove_column :workbags, :vendor_memo_id
    remove_column :workbags, :vendor_memo_no 
    remove_column :workbags, :vendor_memo_date
    remove_column :workbags, :vendor_memo_qty
    remove_column :workbags, :vendor_po_bk
    remove_column :workbags, :vendor_memo_bk
    #two more table
    remove_column :pos_orders, :item_type
    remove_column :pos_orders, :wb_type
    remove_column :contractor_memos, :item_type
    
  end
end

