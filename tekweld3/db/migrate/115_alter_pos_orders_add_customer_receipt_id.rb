class AlterPosOrdersAddCustomerReceiptId < ActiveRecord::Migration
  def self.up
    add_column :pos_orders, :customer_receipt_id, :integer
   
  end

  def self.down
    remove_column :pos_orders, :customer_receipt_id
    
  end
end

