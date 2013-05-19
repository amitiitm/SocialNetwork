class Quotation::SalesQuotationLineCharge < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :sales_quotation_line, :class_name => 'Quotation::SalesQuotationLine'


  def fill_default_detail_values

  end

  def add_line_errors_to_header

  end
end
