xml.instruct! :xml, :version=>"1.0"
xml.catalog_item{
  for catalog_item in @catalog_items
    xml.description(catalog_item.sale_description)
    xml.image_thumnail(catalog_item.image_thumnail)
    xml.item_type(catalog_item.item_type)
    xml.cost(catalog_item.cost)
    xml.unit(catalog_item.unit)

    xml.columns{
      xml.column1(catalog_item.column1)
      xml.column2(catalog_item.column2)
      xml.column3(catalog_item.column3)
      xml.column4(catalog_item.column4)
      xml.column5(catalog_item.column5)
      xml.column6(catalog_item.column6)
      xml.column7(catalog_item.column7)
      xml.column8(catalog_item.column8)
      xml.column9(catalog_item.column9)
      xml.column10(catalog_item.column10)
      xml.column11(catalog_item.column11)
      xml.column12(catalog_item.column12)
      xml.column13(catalog_item.column13)
      xml.column14(catalog_item.column14)
      xml.column15(catalog_item.column15)
    }
    xml.catalog_item_prices{
      for catalog_item_price in catalog_item.catalog_item_prices
        if (catalog_item_price.trans_flag == 'A' and (catalog_item_price.from_date.to_date <= Time.now.to_date) and (Time.now.to_date <= catalog_item_price.to_date.to_date))
          xml.catalog_item_price do
            catalog_item_price.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        end
      end
    }
  end
}
