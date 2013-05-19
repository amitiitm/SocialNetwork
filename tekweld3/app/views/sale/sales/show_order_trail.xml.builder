xml.instruct! :xml, :version=>"1.0" 

xml.orders{
  for order in @orders
    xml.order do
      column_value = format_column(order.trans_date)
      xml.trans_no(order.trans_no)
      xml.trans_date(column_value)
      xml.ext_ref_no(order.ext_ref_no)
      #      xml.order(:trans_no => "#{order.trans_no}",:trans_date => "#{column_value}")
    end
  end
}