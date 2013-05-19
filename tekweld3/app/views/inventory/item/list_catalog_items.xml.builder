xml.instruct! :xml, :version=>"1.0" 
xml.catalog_items{
   for catalog_item in @catalog_items
    xml.catalog_item do
       catalog_item.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.catalog_item_category_code(catalog_item.catalog_item_category.code) if catalog_item.catalog_item_category
    end
 end
}
