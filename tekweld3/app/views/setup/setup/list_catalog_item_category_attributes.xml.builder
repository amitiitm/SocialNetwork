xml.instruct! :xml, :version=>"1.0" 
xml.catalog_item_attributes_values{
  for catalog_item_category_attribute in @catalog_item_category_attributes
    if(catalog_item_category_attribute.catalog_attribute)
      xml.catalog_item_attributes_value do
        #       catalog_item_category_attribute.attributes.each_pair{ |column_name,column_value|
        #        column_value = format_column(column_value)
        #        xml.tag!(column_name, column_value)
        #      }
        xml.catalog_attribute_id(catalog_item_category_attribute.catalog_attribute_id)
        xml.code(catalog_item_category_attribute.catalog_attribute.code)
        xml.attribute_name(catalog_item_category_attribute.catalog_attribute.name)
      end
    end
  end
}
