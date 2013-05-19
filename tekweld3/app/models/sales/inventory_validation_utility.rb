class Sales::InventoryValidationUtility
  include General

  #  def self.validate_inventory(order)
  #    recommendation = ""
  #    order.sales_order_lines.each { |line|
  #      if line.item_type == 'I' and line.trans_flag == 'A'
  #        inventory_summary = Inventory::InventorySummary.find( :first,
  #          :conditions => ["company_id = ? and catalog_item_id = ? ",line.company_id,line.catalog_item_id])
  #        if inventory_summary
  #          total_iss_qty = inventory_summary.stock_iss_qty
  #          if (inventory_summary.stock_rec_qty - inventory_summary.stock_iss_qty) < order.item_qty
  #            recommendation += "Item : #{line.catalog_item_code} Not in Stock"
  #            order.update_attributes!(:recommendation => recommendation,:inventory_status => 'OUT OF STOCK')
  #          else
  #            inventory_summary.update_attributes!(:stock_iss_qty => (order.item_qty + total_iss_qty))
  #            order.update_attributes!(:recommendation => recommendation,:inventory_status => 'STOCK AVAILABLE')
  #          end
  #        else
  #          recommendation += "Item : #{line.catalog_item_code} Not in Stock"
  #          order.update_attributes!(:recommendation => recommendation,:inventory_status => 'OUT OF STOCK')
  #        end
  #      end
  #    }
  #  end



  def self.validate_inventory(order)
    recommendation = ""
    posting_items = identify_posting_items(order)
    posting_items.each { |item_id|
      item = Item::CatalogItem.active.find_by_id(item_id)
      inventory_summary = Inventory::InventorySummary.find( :first,
        :conditions => ["company_id = ? and catalog_item_id = ? ",order.company_id,item.id])
      if inventory_summary
        item_qty = identify_item_total_qty(order,item)
        if (nulltozero(inventory_summary.stock_rec_qty) - nulltozero(inventory_summary.stock_iss_qty)) < item_qty
          recommendation += ", #{item.store_code} NOT IN STOCK"
          #          order.update_attributes!(:recommendation => recommendation,:inventory_status => 'OUT OF STOCK')
        else
          recommendation += ", #{item.store_code} AVAILABLE"
          #            inventory_summary.update_attributes!(:stock_iss_qty => (order.item_qty + total_iss_qty))
          #          order.update_attributes!(:recommendation => recommendation,:inventory_status => 'STOCK AVAILABLE')
        end
      else
        recommendation += ", #{item.store_code} NOT IN STOCK"
        #        order.update_attributes!(:recommendation => recommendation,:inventory_status => 'OUT OF STOCK')
      end
    }
    recommendation = recommendation[1..-1]
    order.recommendation = recommendation ; order.inventory_status = recommendation
  end

  def self.identify_posting_items(order)
    posting_items = []
    order.sales_order_lines.each { |line|
      if line.trans_flag == 'A' and line.item_type != 'S'
        if line.item_type == 'I'
          #          attributes_values = Sales::SalesOrderAttributesValue.find_all_by_sales_order_id_and_catalog_item_id(order.id,line.catalog_item_id)
          attributes_values = identify_attributes_values(order,line)
          attributes_values.each{ |attribute_value|
            if attribute_value.trans_flag == 'A' and attribute_value.catalog_attribute_value_code != ''
              attribute_code = Item::CatalogAttribute.active.find_by_code(attribute_value.catalog_attribute_code)
              catalog_attribute_value = Item::CatalogAttributeValue.active.find_by_catalog_attribute_id_and_code(attribute_code.id,attribute_value.catalog_attribute_value_code)
              if (catalog_attribute_value and catalog_attribute_value.invn_item_id and catalog_attribute_value.invn_item_id != '')
                posting_items << catalog_attribute_value.invn_item_id
              end
            end
          }
        elsif(line.item_type != 'I')
          posting_items << line.catalog_item_id
        end
      end
    }
    ## to avoid repetition of message for same item we are taking unique id's.
    posting_items = posting_items.uniq
    return posting_items
  end

  def self.identify_attributes_values(order,line)
    attributes_values = []
    if (order.trans_type == TRANS_TYPE_REGULAR_ORDER || order.trans_type == TRANS_TYPE_REORDER)
      order.sales_order_attributes_values.each{ |attribute_value|
        attributes_values << attribute_value
      }
    else
      line.sales_order_attributes_values.each{ |attribute_value|
        attributes_values << attribute_value
      }
    end
    attributes_values
  end

  def self.identify_item_total_qty(order,item)
    ## find all by is used bcos if order contains same item multiple times then we have to check the total qty of that item in posting
    item_qty = 0
    #    order_lines = Sales::SalesOrderLine.find_all_by_sales_order_id_and_catalog_item_id(order.id,item.id)
    order.sales_order_lines.each{|line|
      if line.trans_flag == 'A' and line.item_type != 'S'
        if line.item_type == 'I'
          item_qty = item_qty + nulltozero(line.item_qty)
        elsif (line.item_type != 'I' and line.catalog_item_id == item.id)
          item_qty = item_qty + nulltozero(line.item_qty)
        end
      end
    }
    return item_qty
  end
end