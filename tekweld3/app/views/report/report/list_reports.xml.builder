xml.instruct! :xml, :version=>"1.0" 
xml.reports{
  for report in @reports
    xml.report do
      report.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
     
    end
  end
}