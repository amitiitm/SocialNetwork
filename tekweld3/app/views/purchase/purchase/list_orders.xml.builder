xml.instruct! :xml, :version=>"1.0" 
xml.purchase_orders{
   for purchase_order in @orders
    xml.purchase_order do
       purchase_order.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.vendor_code(purchase_order.vendor.code) if purchase_order.vendor
    end
 end
}
