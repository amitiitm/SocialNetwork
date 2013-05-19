xml.instruct! :xml, :version=>"1.0" 
xml.vendors{
  for vendor in @vendors
    xml.vendor do
      vendor.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        column_value =  date_format(column_value) if (column_name =~ /(.*)date(.*)/ )
        xml.tag!(column_name, column_value)
      }
    end
  end
}
