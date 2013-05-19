
xml.instruct! :xml, :version=>"1.0" 
xml.report_layouts{
  for report_layout in @report_layouts
    xml.report_layout do
      xml.name(report_layout.name)
      xml.id(report_layout.id)
      xml.report_id(report_layout.report_id)
      for report_layout_user in report_layout.report_layout_users
        xml.default_yn(report_layout_user.default_yn)
        xml.user_id(report_layout_user.user_id)
      end
      xml.document_id(report_layout.report.document_id)
      xml.layout_type(report_layout.layout_type)
      xml.report_layout_columns{
        for report_layout_column in report_layout.report_layout_columns
          xml.report_layout_column do
            report_layout_column.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        end
      }
    end
  end
}

