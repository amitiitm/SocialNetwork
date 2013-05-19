xml.instruct! :xml, :version=>"1.0"
xml.catalog_item{
  for catalog_item in @catalog_items
    xml.id(catalog_item.id)
    xml.store_code(catalog_item.store_code)
    xml.description(catalog_item.sale_description)
    xml.image_thumnail(catalog_item.image_thumnail)
    xml.item_type(catalog_item.item_type)
    xml.cost(catalog_item.cost)
    xml.unit(catalog_item.unit)
    xml.code(catalog_item.store_code)
    xml.lot_size(catalog_item.lot_size)
    xml.workflow(catalog_item.workflow)
    
    ## this will give blank item price by applying formula on column1 price of anyitem.
    #    item_prices = Item::CatalogItemPrice.find_by_sql ["select blank_good_price from catalog_item_prices where catalog_item_id = #{catalog_item.id} AND trans_flag = 'A' AND  GETDATE() BETWEEN from_date and to_date"]
    #    xml.blank_good_price(item_prices[0].blank_good_price)
    ## to define item price according to item quantity in order screen  
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
    ## to define customer specific price in between date range and charge code
    if @cust_prices 
      xml.catalog_item_prices{
        xml.catalog_item_price{
          xml.column1(@cust_prices.column1)
          xml.column2(@cust_prices.column2)
          xml.column3(@cust_prices.column3)
          xml.column4(@cust_prices.column4)
          xml.column5(@cust_prices.column5)
          xml.column6(@cust_prices.column6)
          xml.column7(@cust_prices.column7)
          xml.column8(@cust_prices.column8)
          xml.column9(@cust_prices.column9)
          xml.column10(@cust_prices.column10)
          xml.column11(@cust_prices.column11)
          xml.column12(@cust_prices.column12)
          xml.column13(@cust_prices.column13)
          xml.column14(@cust_prices.column14)
          xml.column15(@cust_prices.column15)
          xml.blank_good_price(@cust_prices.blank_good_price)
        }
      }
    else
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
    ## added on 4 June 2012 by Amit Pandey if price is less then LTM then price from Item Master is given
    xml.ltm_price{
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
    }
    ## NEWLY ADDED FOR DETAIL ITEM OPTION USED IN VIRTUAL ORDER SCREEN TO FETCH MULTIPLE OPTIONS OF MULTIPLE ITEMS IN GRID
    xml.attributes{
      ## this Select Query is used to fetch catalog_item_attributes_values on basis of catalog_attribute_id
      citem_attribute_values = Item::CatalogItemAttributesValue.find_by_sql("select
                      distinct seq_no,trans_flag,catalog_item_id,catalog_attribute_id from catalog_item_attributes_values where
                      catalog_item_id = #{catalog_item.id} order by seq_no") if catalog_item  
      citem_attribute_values.each{|citem_attribute_value|
        if citem_attribute_value.trans_flag == 'A'
          xml.attribute do
            xml.code(citem_attribute_value.catalog_attribute.code)
            xml.missing_info_required_flag(citem_attribute_value.catalog_attribute.missing_info_required_flag)
            #            xml.name(citem_attribute_value.catalog_attribute.name)
            #            xml.description(citem_attribute_value.catalog_attribute.description)

            xml.values{
              cia_values = Item::CatalogItemAttributesValue.find_by_sql("select * from catalog_item_attributes_values where trans_flag = 'A' and catalog_attribute_value_id <> 0 and catalog_item_id = #{catalog_item.id} and  catalog_attribute_id = #{citem_attribute_value.catalog_attribute_id}") if catalog_item.catalog_item_attributes_values
              if cia_values[1]
                xml.value{
                  xml.default_value("N")
                  xml.code("")
                }
              end
              cia_values.each{|cia_value|
                if cia_value.trans_flag == 'A' and cia_value.catalog_attribute_value and cia_value.catalog_attribute_value.trans_flag == 'A'
                  xml.value do

                    xml.default_value(cia_value.default_value) if cia_value.catalog_attribute_value
                    xml.code(cia_value.catalog_attribute_value.code) if cia_value.catalog_attribute_value
                    #                  xml.name(cia_value.catalog_attribute_value.name) if cia_value.catalog_attribute_value
                    #                  xml.description(cia_value.catalog_attribute_value.description) if cia_value.catalog_attribute_value
                  end
                end
              }
            }
          end
        end
      }
    }
  end
}
