xml.instruct! :xml, :version=>"1.0"
xml.default_setup_lines{
  for catalog_item in @default_setup_items
    xml.sales_order_line{
      xml.item_description(catalog_item.sale_description)
      xml.image_thumnail(catalog_item.image_thumnail)
      xml.item_type(catalog_item.item_type)
      xml.line_type("S")
      xml.unit(catalog_item.unit)
      xml.cost(catalog_item.cost)
      xml.name(catalog_item.name)
      xml.catalog_item_code(catalog_item.store_code)
      xml.setup_item_id(catalog_item.id)
      xml.catalog_item_id(catalog_item.id)
      xml.scope_flag(catalog_item.scope_flag)
      xml.workflow(catalog_item.workflow)
      xml.qty_dependable_flag(catalog_item.qty_dependable_flag)
      xml.id('')
      ## to define customer specific price in between date range and charge code
      if @customer_prices
        xml.item_price(@customer_prices.column1)
        xml.item_qty(1)
        xml.item_amt(1*(@customer_prices.column1))
      else
        for catalog_item_price in catalog_item.catalog_item_prices
          if (catalog_item_price.trans_flag == 'A' and (catalog_item_price.from_date.to_date <= Time.now.to_date) and (Time.now.to_date <= catalog_item_price.to_date.to_date))
            xml.item_price(catalog_item_price.column1)
            xml.item_qty(1)
            xml.item_amt(1*(catalog_item_price.column1))
          end
        end
      end
    }
  end
}



