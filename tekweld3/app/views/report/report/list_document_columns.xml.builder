xml.instruct! :xml, :version=>"1.0" 
xml.report_columns{
  for report_column in @report_columns
    if report_column.trans_flag=='A'
      xml.report_column do
        report_column.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          xml.tag!(column_name, column_value)
        }
      end
    end
  end
}