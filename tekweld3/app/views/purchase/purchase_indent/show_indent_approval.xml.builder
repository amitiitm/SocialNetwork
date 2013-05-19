xml.instruct! :xml, :version=>"1.0" 
xml.indent_approvals{
    for indent_approval in @indent_approvals
    xml.indent_approval do
      indent_approval.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
#      xml.packet_require_yn(indent_approval.catalog_item.packet_require_yn)
   end
 end
}
