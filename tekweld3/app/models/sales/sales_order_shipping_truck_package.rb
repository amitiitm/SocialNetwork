class Sales::SalesOrderShippingTruckPackage < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :sales_order_shipping, :class_name => 'Sales::SalesOrderShipping'


  def fill_default_detail_values

  end

  def add_line_errors_to_header

  end
end
