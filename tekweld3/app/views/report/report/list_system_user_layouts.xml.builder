xml.report_layouts{
  for report_layout in @report_layouts 
    if report_layout.trans_flag=='A'
      xml.report_layout do
        xml.name(report_layout.name)
        xml.id(report_layout.id)
        xml.report_id(report_layout.report_id)
        xml.default_yn(report_layout.default_yn)
        xml.user_id(report_layout.user_id)
        xml.document_id(report_layout.document_id)
        xml.print_orientation(report_layout.print_orientation)
        xml.layout_type(report_layout.layout_type)
        xml.lockedcolumncount(report_layout.lockedcolumncount)
        #changes done by Praman
        report = Report::ReportLayoutColumn.find_by_sql("select drilldown_component_code,isfixedurl,isdrilldownrow from reports where id=#{report_layout.report_id}").first
        xml.drilldown_component_code(report.drilldown_component_code)
        xml.isfixedurl(report.isfixedurl)
        xml.isdrilldownrow(report.isdrilldownrow)
        xml.report_layout_columns{
          report_layout_columns =  Report::ReportLayoutColumn.find_by_sql(" select isgroup,column_sequence,report_column_id,column_datatype,sortdatatype,isdrilldowncolumn,column_name,column_precision,column_label,
                                                                      column_width,column_textalign,istotal,isvisible,group_level,report_layout_columns.print_width,drilldown_component_code,isfixedurl
                                                                      from report_layout_columns inner join report_columns on report_columns.id = report_column_id where report_columns.trans_flag = 'A' and
                                                                      report_layout_columns.report_layout_id = #{report_layout.id} order by column_sequence")
          report_layout_columns.each {|report_layout_column|
            xml.report_layout_column do
              xml.isgroup(report_layout_column.isgroup)
              xml.column_sequence(report_layout_column.column_sequence)
              xml.report_column_id(report_layout_column.report_column_id)
              xml.column_datatype(report_layout_column.column_datatype)
              xml.sortdatatype(report_layout_column.sortdatatype)
              xml.isdrilldowncolumn(report_layout_column.isdrilldowncolumn)
              xml.column_name(report_layout_column.column_name)
              xml.column_precision(report_layout_column.column_precision)
              xml.column_label(report_layout_column.column_label)
              xml.column_width(report_layout_column.column_width)
              xml.column_textalign(report_layout_column.column_textalign)
              xml.istotal(report_layout_column.istotal)
              xml.lockedcolumncount(report_layout.lockedcolumncount)
              xml.print_orientation(report_layout.print_orientation)
              xml.isvisible(report_layout_column.isvisible)
              xml.group_level(report_layout_column.group_level)
              xml.print_width(report_layout_column.print_width)
              xml.drilldown_component_code(report_layout_column.drilldown_component_code)
              xml.isfixedurl(report_layout_column.isfixedurl)
            end
          }
        }
      end
    end
  end
}