xml.instruct! :xml, :version=>"1.0" 
xml.catalog_items{
  for catalog_item in @catalog_items
    xml.catalog_item do
      catalog_item.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        #        column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ and column_value)
        #        column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
        #        column_value = sprintf( "%0.03f", column_value) if (column_name =~ /(.*)wt(.*)/ and column_value and column_name != 'billed_wt_flag')
        #        column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)rate(.*)/ and column_value)
        xml.tag!(column_name, column_value)
      }
      #      xml.item_category_name(catalog_item.catalog_item_category.name)
      #      xml.company_name(catalog_item.company.name)
      #      xml.company_address1(catalog_item.company.address1)
      #      xml.company_address2(catalog_item.company.address2)
      #      xml.company_city(catalog_item.company.city)
      #      xml.company_state(catalog_item.company.state)
      #      xml.company_zip(catalog_item.company.zip)
      #      xml.company_phone(catalog_item.company.phone)
      #      xml.company_fax(catalog_item.company.fax)
      #      xml.company_country(catalog_item.company.country)
      #      column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)price(.*)/ )
      #      catalog_item.catalog_item_extensions.each{|extension|
      #        xml.markup_price(sprintf("%0.02f",(extension.price - extension.total_cost))) if extension.price and extension.total_cost
      #        xml.wt(sprintf( "%0.03f", extension.wt)) if extension.wt
      #	xml.min_wt(sprintf( "%0.03f", extension.min_wt)) if extension.min_wt
      #	xml.max_wt(sprintf( "%0.03f", extension.max_wt)) if extension.max_wt
      #        xml.subtotal_cost(sprintf( "%0.02f", extension.subtotal_cost)) if extension.subtotal_cost
      #        xml.vendor_po_cost(sprintf( "%0.02f", extension.vendor_po_cost)) if extension.vendor_po_cost
      #	xml.mm_size(extension.mm_size)
      #	xml.style_cost(sprintf( "%0.02f", extension.style_cost)) if extension.style_cost
      #	xml.finishing_labor_cost(sprintf( "%0.02f", extension.finishing_labor_cost)) if extension.finishing_labor_cost
      #	xml.finishing_labor_mu(extension.finishing_labor_mu)
      #	xml.finishing_labor_amt(sprintf( "%0.02f", extension.finishing_labor_amt)) if extension.finishing_labor_amt
      #	xml.finishinglabor_mu_retail(extension.finishinglabor_mu_retail)
      #	xml.finishinglabor_amt_retail(sprintf( "%0.02f", extension.finishinglabor_amt_retail)) if extension.finishinglabor_amt_retail
      #	xml.settinglabor_cost(sprintf( "%0.02f", extension.settinglabor_cost)) if extension.settinglabor_cost
      #	xml.settinglabor_mu(extension.settinglabor_mu)
      #	xml.settinglabor_amt(sprintf( "%0.02f", extension.settinglabor_amt)) if extension.settinglabor_amt
      #	xml.setter_instrucion(extension.setter_instrucion)
      #	xml.settinglabor_mu_retail(extension.settinglabor_mu_retail)
      #	xml.settinglabor_amt_retail(sprintf( "%0.02f", extension.settinglabor_amt_retail)) if extension.settinglabor_amt_retail
      #	xml.other_cost(sprintf( "%0.02f", extension.other_cost)) if extension.other_cost
      #	xml.other_mu(extension.other_mu)
      #	xml.other_amt(sprintf( "%0.02f", extension.other_amt)) if extension.other_amt
      #	xml.other_mu_retail(extension.other_mu_retail)
      #	xml.other_amt_retail(sprintf( "%0.02f", extension.other_amt_retail)) if extension.other_amt_retail
      #	xml.total_cost(sprintf( "%0.02f", extension.total_cost)) if extension.total_cost
      #	xml.markup_per(extension.markup_per)
      #	xml.price(sprintf( "%0.02f", extension.price)) if extension.price
      #	xml.mu_margin_flag(extension.mu_margin_flag)
      #	xml.certificate(extension.certificate)
      #	xml.surcharge_per(extension.surcharge_per)
      #	xml.surcharge_amt(sprintf( "%0.02f", extension.surcharge_amt)) if extension.surcharge_amt
      #	xml.discount_per(extension.discount_per)
      #	xml.discount_amt(sprintf( "%0.02f", extension.discount_amt)) if extension.discount_amt
      #	xml.duty_per(extension.duty_per)
      #	xml.duty_amt(sprintf( "%0.02f", extension.duty_amt)) if extension.duty_amt
      #	xml.markup_per_retail(extension.markup_per_retail)
      #	xml.retail_price(sprintf( "%0.02f", extension.retail_price)) if extension.retail_price
      #        xml.vendor_fixed_cost(extension.vendor_fixed_cost) if extension.vendor_fixed_cost
      #      }
      xml.catalog_item_lines{
        for catalog_item_line in catalog_item.catalog_item_lines
          if catalog_item_line.trans_flag =='A'
            xml.catalog_item_line do
              catalog_item_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ and column_value)
                #                column_value = sprintf( "%0.03f", column_value) if (column_name =~ /(.*)wt(.*)/ and column_value and column_name != 'billed_wt_flag')
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)rate(.*)/ and column_value)
                xml.tag!(column_name, column_value)
              }
              xml.catalog_item_code(catalog_item_line.assemble_item.store_code)
              xml.catalog_item_name(catalog_item_line.assemble_item.name)
              xml.description(catalog_item_line.assemble_item.sale_description)
              xml.unit(catalog_item_line.assemble_item.unit)
              xml.price(catalog_item_line.assemble_item.cost)
            end
          end
        end
      }
      xml.catalog_item_prices{
        for catalog_item_price in catalog_item.catalog_item_prices
          if catalog_item_price.trans_flag =='A'
            xml.catalog_item_price do
              catalog_item_price.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ and column_value)
                #                column_value = sprintf( "%0.03f", column_value) if (column_name =~ /(.*)wt(.*)/ and column_value and column_name != 'billed_wt_flag')
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)rate(.*)/ and column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      xml.catalog_item_production_days{
        for catalog_item_production_day in catalog_item.catalog_item_production_days
          if catalog_item_production_day.trans_flag =='A'
            xml.catalog_item_production_day do
              catalog_item_production_day.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      xml.catalog_item_similar_items{
        for catalog_item_similar_item in catalog_item.catalog_item_similar_items
          if catalog_item_similar_item.trans_flag =='A'
            xml.catalog_item_similar_item do
              catalog_item_similar_item.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ and column_value)
                #                column_value = sprintf( "%0.03f", column_value) if (column_name =~ /(.*)wt(.*)/ and column_value and column_name != 'billed_wt_flag')
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)rate(.*)/ and column_value)
                xml.tag!(column_name, column_value)
              }
              xml.item_description(catalog_item_similar_item.similar_item.sale_description)
            end
          end
        end
      }


      xml.catalog_item_others{
        for catalog_item_other in catalog_item.catalog_item_others
          if catalog_item_other.trans_flag =='A'
            xml.catalog_item_other do
              catalog_item_other.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ and column_value)
                #                column_value = sprintf( "%0.03f", column_value) if (column_name =~ /(.*)wt(.*)/ and column_value and column_name != 'billed_wt_flag')
                #                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)rate(.*)/ and column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      xml.catalog_item_images{
        for catalog_item_image in catalog_item.catalog_item_images
          if catalog_item_image.trans_flag =='A'
            xml.catalog_item_image do
              catalog_item_image.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      
      xml.catalog_item_packages{
        for catalog_item_package in catalog_item.catalog_item_packages
          if catalog_item_package.trans_flag =='A'
            xml.catalog_item_package do
              catalog_item_package.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      xml.catalog_item_workflows{
        for catalog_item_workflow in catalog_item.catalog_item_workflows
          if catalog_item_workflow.trans_flag =='A'
            xml.catalog_item_workflow do
              catalog_item_workflow.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      
      xml.catalog_item_setups{
        for catalog_item_setup in catalog_item.catalog_item_setups
          if catalog_item_setup.trans_flag =='A'
            xml.catalog_item_setup do
              catalog_item_setup.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                xml.tag!(column_name, column_value)
              }
              xml.catalog_item_code(catalog_item_setup.setup_item.store_code)
              xml.catalog_item_name(catalog_item_setup.setup_item.name)
              xml.description(catalog_item_setup.setup_item.sale_description)
              xml.unit(catalog_item_setup.setup_item.unit)
              xml.price(catalog_item_setup.setup_item.cost)
            end
          end
        end
      }
      
      xml.catalog_item_accessories{
        for catalog_item_accessory in catalog_item.catalog_item_accessories
          if catalog_item_accessory.trans_flag =='A'
            xml.catalog_item_accessory do
              catalog_item_accessory.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)cost(.*)/ and column_value)
                xml.tag!(column_name, column_value)
              }
              xml.catalog_item_code(catalog_item_accessory.accessory_item.store_code)
              xml.catalog_item_name(catalog_item_accessory.accessory_item.name)
              xml.description(catalog_item_accessory.accessory_item.sale_description)
              xml.unit(catalog_item_accessory.accessory_item.unit)
              xml.price(catalog_item_accessory.accessory_item.cost)
            end
          end
        end
      }
      xml.catalog_item_price_levels{
        for catalog_item_price_level in catalog_item.catalog_item_price_levels
          if catalog_item_price_level.trans_flag =='A'
            xml.catalog_item_price_level do
              catalog_item_price_level.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }

      xml.catalog_item_shippings{
        for catalog_item_shipping in catalog_item.catalog_item_shippings
          if catalog_item_shipping.trans_flag =='A'
            xml.catalog_item_shipping do
              catalog_item_shipping.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }

      xml.catalog_item_templates{
        for catalog_item_template in catalog_item.catalog_item_templates
          if catalog_item_template.trans_flag =='A'
            xml.catalog_item_template do
              catalog_item_template.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
      ## NEWLY Added For catalog_item_attributes_values to display multiple attributes for one item
      item_category_attributes = []
      xml.catalog_item_attributes_values{
        ## this Select Query is used to fetch catalog_item_attributes_values on basis of catalog_attribute_id
        citem_attribute_values = Item::CatalogItemAttributesValue.find_by_sql("select 
                      distinct seq_no,trans_flag,catalog_item_id,catalog_attribute_id from catalog_item_attributes_values where 
                      catalog_item_id = #{catalog_item.id} order by seq_no") if catalog_item 
        citem_attribute_values.each{|citem_attribute_value|
          if citem_attribute_value.trans_flag == 'A'
            xml.catalog_item_attributes_value do
              xml.catalog_attribute_id(citem_attribute_value.catalog_attribute_id)
              xml.catalog_item_id(citem_attribute_value.catalog_item_id)
              xml.attribute_name(citem_attribute_value.catalog_attribute.name)   
              
              xml.attribute_values{
                cia_values = Item::CatalogItemAttributesValue.find_by_sql("select * from catalog_item_attributes_values where catalog_item_id = #{catalog_item.id} and  catalog_attribute_id = #{citem_attribute_value.catalog_attribute_id}") if catalog_item.catalog_item_attributes_values
                cia_values.each{|cia_value|
                  xml.attribute_value do
                    xml.catalog_attribute_value_id(cia_value.catalog_attribute_value_id) #if cia_value.trans_flag == 'A'
                    xml.value_name(cia_value.catalog_attribute_value.name) if cia_value.catalog_attribute_value
                    xml.id(cia_value.id) 
                    xml.company_id(cia_value.company_id)
                    xml.created_by(cia_value.created_by)
                    xml.updated_by(cia_value.updated_by)
                    xml.created_at(cia_value.created_at)
                    xml.updated_at(cia_value.updated_at)
                    xml.update_flag(cia_value.update_flag)
                    xml.trans_flag(cia_value.trans_flag)
                    xml.lock_version(cia_value.lock_version)
                    xml.default_value(cia_value.default_value)
                  end
                }
              }  
            end  
          end          
          item_category_attributes << citem_attribute_value.catalog_attribute_id          
        }      
        #        for catalog_item_category_attribute in catalog_item.catalog_item_category.catalog_item_category_attributes
        #          if not item_category_attributes.include?(catalog_item_category_attribute.catalog_attribute_id)
        #            xml.catalog_item_attributes_value do
        #              xml.catalog_item_id(catalog_item_category_attribute.catalog_attribute_id)
        #              xml.catalog_attribute_id(catalog_item_category_attribute.catalog_attribute_id)
        #              xml.catalog_attribute_value_id("")
        #              xml.attribute_name(catalog_item_category_attribute.catalog_attribute.name) if catalog_item_category_attribute.catalog_attribute
        #            end
        #          end
        #        end
      }      
      xml.catalog_attribute_values("")
    end
  end
}
