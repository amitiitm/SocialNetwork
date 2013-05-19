xml.instruct! :xml, :version=>"1.0" 
xml.vendor_backdated_aging_details{
  for aging in @agings
    xml.vendor_backdated_aging_detail do
#      aging.attributes.each_pair{ |column_name,column_value|
      aging.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        column_value =  date_format(column_value) if (column_name =~ /(.*)date(.*)/ )
        xml.tag!(column_name, column_value)
      }
    end
  end
}
