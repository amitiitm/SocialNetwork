class Quotation::SalesQuotationAttributesValue < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :sales_quotation, :class_name => 'Quotation::SalesQuotation'
  belongs_to :sales_quotation_line, :class_name => 'Quotation::SalesQuotationLine'
  #  validates_uniqueness_of :serial_no, :scope=>[:sales_order_id]

  def add_line_errors_to_header
    
  end
end