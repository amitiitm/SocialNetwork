class Setup::CompanyStore < ActiveRecord::Base
    include UserStamp
    include Dbobject
  
    has_many  :purchase_orders, :class_name => 'PurchaseOrder::PurchaseOrder'
    has_many  :purchase_invoices, :class_name => 'PurchaseInvoice::PurchaseInvoice'
#    has_many  :purchase_cancellations
    belongs_to :company
end
