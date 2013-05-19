xml.instruct! :xml, :version=>"1.0" 
xml.catalog_item_prices{
  for catalog_item_price in  @item
    xml.catalog_item_price do
      catalog_item_price.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.catalog_item_code(catalog_item_price.catalog_item.store_code) if catalog_item_price.catalog_item
      xml.status(catalog_item_price.status)
      xml.update(catalog_item_price.update)
      
    end
  end
}
