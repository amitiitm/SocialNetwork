xml.instruct! :xml, :version=>"1.0" 
xml.catalog_item_categories{
  for catalog_item_category in @catalog_item_categories
    xml.catalog_item_category do
      catalog_item_category.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.catalog_item_category_attributes{
        for catalog_item_category_attribute in catalog_item_category.catalog_item_category_attributes
          if catalog_item_category_attribute.trans_flag == 'A'         
            xml.catalog_item_category_attribute do
              catalog_item_category_attribute.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              xml.code(catalog_item_category_attribute.catalog_attribute.code) if catalog_item_category_attribute.catalog_attribute
              xml.name(catalog_item_category_attribute.catalog_attribute.name) if catalog_item_category_attribute.catalog_attribute
            end
          end
        end
      }
    end
  end
}
