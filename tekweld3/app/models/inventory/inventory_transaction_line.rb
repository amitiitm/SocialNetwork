class Inventory::InventoryTransactionLine < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods

  belongs_to :inventory_transaction, :class_name => 'Inventory::InventoryTransaction'
  belongs_to :company, :class_name => 'Setup::Company'
  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
  belongs_to :catalog_item_packet, :class_name => 'Item::CatalogItemPacket'

  validates_uniqueness_of :serial_no, :scope=>[:trans_no, :trans_bk, :trans_date,:company_id]
  validates :catalog_item_id, :presence => true
  
  validates_numericality_of  :rec_qty, :iss_qty, :rec_price, :iss_price, :rec_amt, :iss_amt, :allow_nil=>false, :default=>0

def fill_default_detail_values
  rec_qty ||= nulltozero(rec_qty)
  iss_qty ||= nulltozero(iss_qty)
  rec_price ||= nulltozero(rec_price)
  iss_price ||= nulltozero(iss_price)
  rec_amt ||= nulltozero(rec_amt)
  iss_amt ||= nulltozero(iss_amt)
  trans_bk = 'IN01'
end

end
