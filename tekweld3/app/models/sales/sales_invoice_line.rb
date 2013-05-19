class Sales::SalesInvoiceLine < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods
  include GenericSelects

  belongs_to :sales_invoice, :class_name => 'Sales::SalesInvoice'
  belongs_to :company, :class_name => 'Setup::Company'
  #  belongs_to :company_store, :class_name => 'Setup::CompanyStore'
  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
  has_finder :filter_setup_lines, :conditions => " item_type != 'S' "
 
  validates_uniqueness_of :serial_no, :scope=>[:trans_no, :trans_bk, :trans_date,:company_id]
  validates :catalog_item_id, :presence => true
  #  validates_presence_of :catalog_item_id, :message=>'not exist'
  
  validates_numericality_of  :item_qty, :clear_qty, :ref_qty, :item_price, :allow_nil=>false, :default=>0
  validates_numericality_of  :discount_amt, :net_amt, :allow_nil=>false, :default=>0
  validates_numericality_of  :discount_per,:less_than_or_equal_to=>9999.99,:default=>0
 

  
  before_validation do
    errors.add(:clear_qty,"Invoice Quantity cannot be greater than ordered/memoed quantity") if clear_qty > item_qty
  end

  def fill_default_detail_values
    item_qty ||= nulltozero(item_qty)
    clear_qty ||= nulltozero(clear_qty)
    ref_qty ||= nulltozero(ref_qty)
    item_price ||= nulltozero(item_price)
    discount_per ||= nulltozero(discount_per)
    discount_amt ||= nulltozero(discount_amt)
    net_amt ||= nulltozero(net_amt)
    trans_bk = 'SI01'
  end
end
