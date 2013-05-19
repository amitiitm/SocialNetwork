class Purchase::PurchaseIndentLine < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods
  
  belongs_to :purchase_indent, :class_name => 'Purchase::PurchaseIndent'
  belongs_to :company, :class_name => 'Setup::Company'
  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
  
  validates_uniqueness_of :serial_no, :scope=>[:trans_no, :trans_bk, :trans_date,:company_id]
  validates_presence_of :catalog_item_id, :message=>'Can not be blank'
  
  validates_numericality_of  :item_qty, :clear_qty, :allow_nil=>false, :default=>0
  
  def fill_default_detail_values
    item_qty ||= nulltozero(item_qty)
    clear_qty ||= nulltozero(clear_qty)
    trans_bk = 'PO01'
  end
end
