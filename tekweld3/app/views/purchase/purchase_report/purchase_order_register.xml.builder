xml.instruct! :xml, :version=>"1.0" 
xml.purchase_orders{
  for purchase_order in @orders
    if  purchase_order.line_trans_flag =='A'
      xml.purchase_order do
        purchase_order.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          xml.tag!(column_name, column_value)
        }
      end
    end
  end
}
