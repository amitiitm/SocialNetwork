xml.instruct! :xml, :version=>"1.0" 
xml.purchase_order_cancels{
  for purchase_order_cancel in @order_cancels
    if purchase_order_cancel.line_trans_flag=='A'
      xml.purchase_order_cancel do
        purchase_order_cancel.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          column_value =  date_format(column_value) if (column_name =~ /(.*)date(.*)/ )
          xml.tag!(column_name, column_value)
        }
      end
    end
  end
}
