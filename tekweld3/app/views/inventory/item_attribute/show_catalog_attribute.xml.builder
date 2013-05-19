xml.instruct! :xml, :version=>"1.0" 

xml.catalog_attributes{
    for catalog_attribute in @catalog_attributes
    xml.catalog_attribute do
      catalog_attribute.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.catalog_attribute_values{
        for catalog_attribute_value in catalog_attribute.catalog_attribute_values
          if catalog_attribute_value.trans_flag == 'A'
            xml.catalog_attribute_value do
              catalog_attribute_value.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
   end
 end
}
