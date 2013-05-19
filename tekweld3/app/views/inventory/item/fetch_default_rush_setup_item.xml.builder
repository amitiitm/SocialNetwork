xml.instruct! :xml, :version=>"1.0"
xml.sales_order_lines{
  for catalog_item in @catalog_items
    xml.sales_order_line do
      catalog_item.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value) if column_name != 'id'
      }
      xml.id("")
    end
  end
  xml.sales_order_line{
    xml.label("")
    xml.value("")
  }
}
