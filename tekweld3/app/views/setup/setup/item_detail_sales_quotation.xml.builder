xml.instruct! :xml, :version=>"1.0"
xml.catalog_item{
  for catalog_item in @catalog_items
    xml.description(catalog_item.sale_description)
    xml.image_thumnail(catalog_item.image_thumnail)
    xml.item_type(catalog_item.item_type)
    xml.cost(catalog_item.cost)
    xml.unit(catalog_item.unit)
    xml.lot_size(catalog_item.lot_size)
    xml.workflow(catalog_item.workflow)
    ## this will give blank item price by applying formula on column1 price of anyitem.
    #    item_prices = Item::CatalogItemPrice.find_by_sql ["select * from catalog_item_prices where catalog_item_id = #{catalog_item.id} AND trans_flag = 'A' AND  GETDATE() BETWEEN from_date and to_date"]
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
    #### ARRAYS #####
    attribute_code_array = []
    attribute_value_array = []
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
            ###### below line is removed bcos it is giving only those attributes which contains setup charge but now we r fetching values based on attributes so if any attribute doesnot contain
            # setup charge and its values have charge then those charge are not getting fetched.
            #            attribute_code_array << citem_attribute_value.catalog_attribute.code if (citem_attribute_value.catalog_attribute.setup_item_code and citem_attribute_value.catalog_attribute.setup_item_code != '')
            attribute_code_array << citem_attribute_value.catalog_attribute.code if (citem_attribute_value.catalog_attribute)
            #            xml.setup_item_id(citem_attribute_value.catalog_attribute.setup_item_id)
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

                    xml.default_value(cia_value.default_value)
                    xml.code(cia_value.catalog_attribute_value.code)
                    attribute_value_array << cia_value.catalog_attribute_value.code if (cia_value.catalog_attribute_value.setup_item_code and cia_value.catalog_attribute_value.setup_item_code != '')
                    #                    xml.setup_item_id(cia_value.catalog_attribute_value.setup_item_id) if cia_value.catalog_attribute_value
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
    uniq_attribute_code_array = attribute_code_array.uniq
    uniq_attribute_value_array = attribute_value_array.uniq
    ##### NEW CHANGES #######
    xml.catalog_attribute_codes{
      uniq_attribute_code_array.each{|attribute_code|
        @setup_catalog_item_options1,@setup_cust_option_prices1 = fetch_setup_charge_for_item_options1(attribute_code,@customer_id)
        @setup_catalog_item_options2,@setup_cust_option_prices2 = fetch_setup_charge_for_item_options2(attribute_code,@customer_id)
        for setup_catalog_item in @setup_catalog_item_options1
          xml.sales_quotation_line_charge{
            xml.item_description(setup_catalog_item.sale_description)
            xml.image_thumnail(setup_catalog_item.image_thumnail)
            xml.item_type(setup_catalog_item.item_type)
            xml.line_type("S")
            xml.unit(setup_catalog_item.unit)
            xml.cost(setup_catalog_item.cost)
            xml.name(setup_catalog_item.name)
            xml.catalog_item_code(setup_catalog_item.store_code)
            xml.setup_item_id(setup_catalog_item.id)
            xml.catalog_item_id(setup_catalog_item.id)
            xml.scope_flag(setup_catalog_item.scope_flag)
            xml.workflow(setup_catalog_item.workflow)
            xml.option_code(attribute_code)
            xml.qty_dependable_flag(setup_catalog_item.qty_dependable_flag)
            xml.trans_flag(setup_catalog_item.trans_flag)
            xml.id('')
            ## to define customer specific price in between date range and charge code
            if @setup_cust_option_prices1
              xml.item_price(@setup_cust_option_prices1.column1)
              xml.item_qty(1)
              xml.item_amt(1*(@setup_cust_option_prices1.column1))
            elsif(setup_catalog_item.catalog_item_prices[0])
              for catalog_item_price in setup_catalog_item.catalog_item_prices
                if (catalog_item_price.trans_flag == 'A' and (catalog_item_price.from_date.to_date <= Time.now.to_date) and (Time.now.to_date <= catalog_item_price.to_date.to_date))
                  xml.item_price(catalog_item_price.column1)
                  xml.item_qty(1)
                  xml.item_amt(1*(catalog_item_price.column1))
                end
              end
            else
              xml.item_price(0.00)
              xml.item_qty(0)
              xml.item_amt(0.00)
            end
          }
        end
        ## loop which generates xml containing second setup charges if defined on item options.
        for setup_catalog_item in @setup_catalog_item_options2
          xml.sales_quotation_line_charge{
            xml.item_description(setup_catalog_item.sale_description)
            xml.image_thumnail(setup_catalog_item.image_thumnail)
            xml.item_type(setup_catalog_item.item_type)
            xml.line_type("S")
            xml.unit(setup_catalog_item.unit)
            xml.cost(setup_catalog_item.cost)
            xml.name(setup_catalog_item.name)
            xml.catalog_item_code(setup_catalog_item.store_code)
            xml.setup_item_id(setup_catalog_item.id)
            xml.catalog_item_id(setup_catalog_item.id)
            xml.scope_flag(setup_catalog_item.scope_flag)
            xml.workflow(setup_catalog_item.workflow)
            xml.option_code(attribute_code)
            xml.qty_dependable_flag(setup_catalog_item.qty_dependable_flag)
            xml.trans_flag(setup_catalog_item.trans_flag)
            xml.id('')
            ## to define customer specific price in between date range and charge code
            if @setup_cust_option_prices2
              xml.item_price(@setup_cust_option_prices2.column1)
              xml.item_qty(1)
              xml.item_amt(1*(@setup_cust_option_prices2.column1))
            elsif(setup_catalog_item.catalog_item_prices[0])
              for catalog_item_price in setup_catalog_item.catalog_item_prices
                if (catalog_item_price.trans_flag == 'A' and (catalog_item_price.from_date.to_date <= Time.now.to_date) and (Time.now.to_date <= catalog_item_price.to_date.to_date))
                  xml.item_price(catalog_item_price.column1)
                  xml.item_qty(1)
                  xml.item_amt(1*(catalog_item_price.column1))
                end
              end
            else
              xml.item_price(0.00)
              xml.item_qty(0)
              xml.item_amt(0.00)
            end
          }
        end
      }
    }
    xml.catalog_attribute_values{
      uniq_attribute_code_array.each{|attribute_code|
        attribute_code_obj = Item::CatalogAttribute.active.find_by_code(attribute_code)
        uniq_attribute_value_array = Item::CatalogAttributeValue.active.find_all_by_catalog_attribute_id(attribute_code_obj.id)
        uniq_attribute_value_array.each{|attribute_value|
          if (attribute_value and attribute_value.setup_item_code and attribute_value.setup_item_code != '')
            @setup_catalog_item_values1,@setup_cust_value_prices1 = fetch_setup_charge_for_item_option_values1(attribute_code_obj.id,attribute_value.code,@customer_id)
            @setup_catalog_item_values2,@setup_cust_value_prices2 = fetch_setup_charge_for_item_option_values2(attribute_code_obj.id,attribute_value.code,@customer_id)
            for setup_catalog_item in @setup_catalog_item_values1
              xml.sales_quotation_line_charge{
                xml.item_description(setup_catalog_item.sale_description)
                xml.image_thumnail(setup_catalog_item.image_thumnail)
                xml.item_type(setup_catalog_item.item_type)
                xml.line_type("S")
                xml.unit(setup_catalog_item.unit)
                xml.cost(setup_catalog_item.cost)
                xml.name(setup_catalog_item.name)
                xml.catalog_item_code(setup_catalog_item.store_code)
                xml.setup_item_id(setup_catalog_item.id)
                xml.catalog_item_id(setup_catalog_item.id)
                xml.scope_flag(setup_catalog_item.scope_flag)
                xml.workflow(setup_catalog_item.workflow)
                xml.option_value(attribute_value.code)
                xml.option_code(attribute_code)
                xml.qty_dependable_flag(setup_catalog_item.qty_dependable_flag)
                xml.trans_flag(setup_catalog_item.trans_flag)
                xml.id('')
                ## to define customer specific price in between date range and charge code
                if @setup_cust_value_prices1
                  xml.item_price(@setup_cust_value_prices1.column1)
                  xml.item_qty(1)
                  xml.item_amt(1*(@setup_cust_value_prices1.column1))
                elsif(setup_catalog_item.catalog_item_prices[0])
                  for catalog_item_price in setup_catalog_item.catalog_item_prices
                    if (catalog_item_price.trans_flag == 'A' and (catalog_item_price.from_date.to_date <= Time.now.to_date) and (Time.now.to_date <= catalog_item_price.to_date.to_date))
                      xml.item_price(catalog_item_price.column1)
                      xml.item_qty(1)
                      xml.item_amt(1*(catalog_item_price.column1))
                    end
                  end
                else
                  xml.item_price(0.00)
                  xml.item_qty(0)
                  xml.item_amt(0.00)
                end
              }
            end

            ## this loop will fetch another charge applied on values
            for setup_catalog_item in @setup_catalog_item_values2
              xml.sales_quotation_line_charge{
                xml.item_description(setup_catalog_item.sale_description)
                xml.image_thumnail(setup_catalog_item.image_thumnail)
                xml.item_type(setup_catalog_item.item_type)
                xml.line_type("S")
                xml.unit(setup_catalog_item.unit)
                xml.cost(setup_catalog_item.cost)
                xml.name(setup_catalog_item.name)
                xml.catalog_item_code(setup_catalog_item.store_code)
                xml.setup_item_id(setup_catalog_item.id)
                xml.catalog_item_id(setup_catalog_item.id)
                xml.scope_flag(setup_catalog_item.scope_flag)
                xml.workflow(setup_catalog_item.workflow)
                xml.option_value(attribute_value.code)
                xml.option_code(attribute_code)
                xml.qty_dependable_flag(setup_catalog_item.qty_dependable_flag)
                xml.trans_flag(setup_catalog_item.trans_flag)
                xml.id('')
                ## to define customer specific price in between date range and charge code
                if @setup_cust_value_prices2
                  xml.item_price(@setup_cust_value_prices2.column1)
                  xml.item_qty(1)
                  xml.item_amt(1*(@setup_cust_value_prices2.column1))
                elsif(setup_catalog_item.catalog_item_prices[0])
                  for catalog_item_price in setup_catalog_item.catalog_item_prices
                    if (catalog_item_price.trans_flag == 'A' and (catalog_item_price.from_date.to_date <= Time.now.to_date) and (Time.now.to_date <= catalog_item_price.to_date.to_date))
                      xml.item_price(catalog_item_price.column1)
                      xml.item_qty(1)
                      xml.item_amt(1*(catalog_item_price.column1))
                    end
                  end
                else
                  xml.item_price(0.00)
                  xml.item_qty(0)
                  xml.item_amt(0.00)
                end
              }
            end
          end
        }
      }
    }
    ##################### removed on 16 march for performance improvement i think not in use.//Amit Pandey
    xml.catalog_item_line{
      xml.assemble_items{

      }
      xml.setup_items{

      }
      xml.accessory_items{
        for accessory_item in catalog_item.catalog_item_accessories.active
          xml.accessory_item do
            accessory_item.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
            xml.catalog_item_code(accessory_item.accessory_item.store_code)
            xml.catalog_item_name(accessory_item.accessory_item.name)
            xml.description(accessory_item.accessory_item.sale_description)
            xml.unit(accessory_item.accessory_item.unit)
            xml.price(accessory_item.accessory_item.cost)
          end
        end

      }
    }
  end
  #these changes are done bcos in embroidery we have to add separate setup charge for qty < 144(required in front hand)
  xml.stitch_charges{
    embroidery_setups = Item::CatalogItem.find_by_sql ["select * from catalog_items where store_code = 'EMBROIDERY-SETUP'"]
    for embroidery_setup in embroidery_setups
      xml.sales_quotation_line_charges{
        xml.sales_quotation_line_charge{
          xml.item_description(embroidery_setup.sale_description)
          xml.image_thumnail(embroidery_setup.image_thumnail)
          xml.item_type(embroidery_setup.item_type)
          xml.line_type("S")
          xml.unit(embroidery_setup.unit)
          xml.cost(embroidery_setup.cost)
          xml.name(embroidery_setup.name)
          xml.catalog_item_code(embroidery_setup.store_code)
          xml.setup_item_id(embroidery_setup.id)
          xml.catalog_item_id(embroidery_setup.id)
          xml.scope_flag(embroidery_setup.scope_flag)
          xml.workflow(embroidery_setup.workflow)
          xml.trans_flag(embroidery_setup.trans_flag)
          xml.qty_dependable_flag(embroidery_setup.qty_dependable_flag)
          xml.id('')
          for catalog_item_price in embroidery_setup.catalog_item_prices
            if (catalog_item_price.trans_flag == 'A' and (catalog_item_price.from_date.to_date <= Time.now.to_date) and (Time.now.to_date <= catalog_item_price.to_date.to_date))
              xml.item_price(catalog_item_price.column1)
              xml.item_qty(1)
              xml.item_amt(1*(catalog_item_price.column1))
            end
          end
        }
      }
    end
  }
}