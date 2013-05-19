class Setup::Shipping < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  
  has_many:purchase_orders,  :class_name => 'PurchaseOrder::PurchaseOrder'
  has_many:purchase_invoices ,:class_name => 'PurchaseInvoice::PurchaseInvoice'
#  has_many:purchase_cancellations
  validates_uniqueness_of :code

  def add_line_errors_to_header
  end
end
