xml.instruct! :xml, :version=>"1.0" 
xml.vendors{
   for vendor in @vendors
    xml.vendor do
       vendor.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.gl_account_code(vendor.gl_account.code)
    end
 end
}

