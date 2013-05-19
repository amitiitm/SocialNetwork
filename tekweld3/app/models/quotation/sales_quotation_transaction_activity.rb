class Quotation::SalesQuotationTransactionActivity < ActiveRecord::Base

   belongs_to :sales_quotation , :class_name => 'Quotation::SalesQuotation'
end
