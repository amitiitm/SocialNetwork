xml.instruct! :xml, :version=>"1.0" 
xml.vendor_payments{
  for vendor_payment in  @payments
    if (vendor_payment.line_trans_flag=='A' or vendor_payment.line_trans_flag== nil )
      xml.vendor_payment do
        vendor_payment.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          column_value =  date_format(column_value) if (column_name =~ /(.*)date/ )
          xml.tag!(column_name, column_value)
        }
      end
    end   
  end
}