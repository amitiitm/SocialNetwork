class Inventory::InventoryTransfer < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods

#  belongs_to :issue_transaction, :class_name => 'Inventory::InventoryTransactionLine',
#                        :foreign_key => "inventory_transacton_line_id"
#  belongs_to :receive_transaction, :class_name => 'Inventory::InventoryTransactionLine',
#                        :foreign_key => "inventory_transacton_line_id"
  belongs_to :company, :class_name => 'Setup::Company'
  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'

  validates :catalog_item_id, :presence => true
  
  validates_numericality_of  :transfer_qty, :transfer_price, :transfer_amt, :allow_nil=>false, :default=>0

def fill_default_detail_values
  transfer_qty ||= nulltozero(transfer_qty)
  transfer_price ||= nulltozero(transfer_price)
  transfer_amt ||= nulltozero(transfer_amt)
  trans_bk = 'TR01'
end

end
