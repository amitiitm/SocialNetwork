xml.instruct! :xml, :version=>"1.0"

xml.indigo_impositions{
  if @gum_imposition
    xml.indigo_imposition do
      @gum_imposition.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
        sales_order_lines = Sales::SalesOrderLine.find_all_by_doc_code(@gum_imposition.doc_code)
        xml.sales_order_lines{
          for sales_order_line in sales_order_lines
            xml.sales_order_line do
              sales_order_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        }
    end
  end
}