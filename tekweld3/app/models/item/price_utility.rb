class Item::PriceUtility
  include General
  
  ## FUNCTION to fetch customer specific price in between date range and charge code on the basis of item_id and cust_id
  def self.fetch_cust_specific_price(catalog_item_id,customer_id)
    catalog_item = Item::CatalogItem.find_all_by_id(catalog_item_id)
    cust_prices = Customer::CustomerItemPricing.find_by_sql ["select * from customer_item_pricings where catalog_item_id = #{catalog_item_id} AND customer_id = #{customer_id} AND trans_flag = 'A' AND  GETDATE() BETWEEN from_date and to_date"]
    if cust_prices[0]
      for cust_price in cust_prices
        if (cust_price.charge_code != '')
          customer_specific_price = apply_charge_code(cust_price.charge_code,cust_price,catalog_item)
        else
          customer_specific_price = cust_price
        end
      end
    else
      item = Item::CatalogItem.find_all_by_store_code('ALL')
      if item[0]
        cust_prices = Customer::CustomerItemPricing.find_by_sql ["select * from customer_item_pricings where catalog_item_id = #{item[0].id} AND customer_id = #{customer_id} AND trans_flag = 'A' AND  GETDATE() BETWEEN from_date and to_date"]
        if cust_prices[0]
          for cust_price in cust_prices
            if (cust_price.charge_code != '')
              customer_specific_price = apply_charge_code(cust_price.charge_code,cust_price,catalog_item)
            else
              customer_specific_price = cust_price
            end
          end
        end
      end
    end
    return catalog_item,customer_specific_price
  end
  
  ## FUNCTION to fetch customer specific price in between date range and charge code on the basis of item_id and cust_id also used for fetching accessory item price
  def self.fetch_cust_specific_setup_item_price(catalog_item_id,customer_id)
    catalog_item = Item::CatalogItem.find_all_by_id(catalog_item_id)
    cust_prices = Customer::CustomerItemPricing.find_by_sql ["select * from customer_item_pricings where catalog_item_id = #{catalog_item_id} AND customer_id = #{customer_id} AND trans_flag = 'A' AND  GETDATE() BETWEEN from_date and to_date"]
    if cust_prices[0]
      for cust_price in cust_prices
        if (cust_price.charge_code != '')
          customer_specific_price = apply_charge_code(cust_price.charge_code,cust_price,catalog_item)
        else
          customer_specific_price = cust_price
        end
      end
    end
    return catalog_item,customer_specific_price
  end
  
  def self.apply_charge_code(charge_code,cust_price,catalog_item)
    item_prices = Item::CatalogItemPrice.find_by_sql ["select * from catalog_item_prices where catalog_item_id = #{catalog_item[0].id} AND trans_flag = 'A' AND  GETDATE() BETWEEN from_date and to_date"]
    return if !item_prices[0]
    case charge_code
    when 'EQP'
      then 
      last_column_price = find_last_column_price(item_prices[0])
      customer_specific_price = set_last_column_price(cust_price,last_column_price,item_prices[0])
    when '10%'
      then 
      customer_specific_price = set_individual_column_price(cust_price,10,item_prices[0])
    when '20%'
      then 
      customer_specific_price = set_individual_column_price(cust_price,20,item_prices[0])
    when 'EQP-2%'
      then 
      last_column_price = find_last_column_price(item_prices[0])
      customer_specific_price = set_last_column_price(cust_price,(last_column_price - (last_column_price * 2)/100),item_prices[0])
    when 'EQP-2.5%'
      then
      last_column_price = find_last_column_price(item_prices[0])            
      customer_specific_price = set_last_column_price(cust_price,(last_column_price - (last_column_price * 2.5)/100),item_prices[0])
    when 'EQP-3%'
      then 
      last_column_price = find_last_column_price(item_prices[0])
      customer_specific_price = set_last_column_price(cust_price,(last_column_price - (last_column_price * 3)/100),item_prices[0])
    when 'EQP-Domestic'
      if catalog_item[0].scope_flag == 'D'
        last_column_price = find_last_column_price(item_prices[0])
        customer_specific_price = set_last_column_price(cust_price,last_column_price,item_prices[0])
      end
    when 'NQP'
      then
      customer_specific_price = set_nqp_column_price(cust_price,item_prices[0])
    when 'LTM'
      then 
      customer_specific_price = cust_price
    end
    return customer_specific_price
  end
  
  
  def self.find_last_column_price(item_price)
    if nulltozero(item_price.end_quantity_price.to_i) == 15
      return nulltozero(item_price.column15)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 14
      return nulltozero(item_price.column14)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 13
      return nulltozero(item_price.column13)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 12
      return nulltozero(item_price.column12)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 11
      return nulltozero(item_price.column11)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 10
      return nulltozero(item_price.column10)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 9
      return nulltozero(item_price.column9)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 8
      return nulltozero(item_price.column8)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 7
      return nulltozero(item_price.column7)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 6
      return nulltozero(item_price.column6)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 5
      return nulltozero(item_price.column5)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 4
      return nulltozero(item_price.column4)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 3
      return nulltozero(item_price.column3)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 2
      return nulltozero(item_price.column2)
    elsif nulltozero(item_price.end_quantity_price.to_i) == 1
      return nulltozero(item_price.column1)
    else
      return nulltozero(item_price.column10)
    end    
  end
  
  #  def self.set_last_column_price1(cust_price,last_column_price,item_price)
  #    cust_price.column1 = last_column_price
  #    cust_price.column2 = last_column_price
  #    cust_price.column3 = last_column_price
  #    cust_price.column4 = last_column_price
  #    cust_price.column5 = last_column_price
  #    cust_price.column6 = last_column_price
  #    cust_price.column7 = last_column_price
  #    cust_price.column8 = last_column_price
  #    cust_price.column9 = last_column_price
  #    cust_price.column10 = last_column_price
  #  end

  def self.set_last_column_price(cust_price,last_column_price,item_price)
    eqp = nulltozero(item_price.end_quantity_price)
    i = 1
    eqp.to_i.times { |i|
      i += 1
      column_name = "column#{i}"
      cust_price[column_name] = last_column_price  
    }
    a = eqp + 1
    a.upto(15){ |i|
      column_name = "column#{i}"
      cust_price[column_name] = item_price[column_name]
      i += 1}
    return cust_price
  end

  def self.set_individual_column_price(cust_price,percentage,item_price)
    cust_price.column1 = (nulltozero(item_price.column1) - (nulltozero(item_price.column1) * percentage)/100)
    cust_price.column2 = (nulltozero(item_price.column2) - (nulltozero(item_price.column2) * percentage)/100)
    cust_price.column3 = (nulltozero(item_price.column3) - (nulltozero(item_price.column3) * percentage)/100)
    cust_price.column4 = (nulltozero(item_price.column4) - (nulltozero(item_price.column4) * percentage)/100)
    cust_price.column5 = (nulltozero(item_price.column5) - (nulltozero(item_price.column5) * percentage)/100)
    cust_price.column6 = (nulltozero(item_price.column6) - (nulltozero(item_price.column6) * percentage)/100)
    cust_price.column7 = (nulltozero(item_price.column7) - (nulltozero(item_price.column7) * percentage)/100)
    cust_price.column8 = (nulltozero(item_price.column8) - (nulltozero(item_price.column8) * percentage)/100)
    cust_price.column9 = (nulltozero(item_price.column9) - (nulltozero(item_price.column9) * percentage)/100)
    cust_price.column10 = (nulltozero(item_price.column10) - (nulltozero(item_price.column10) * percentage)/100)
    cust_price.column11 = (nulltozero(item_price.column11) - (nulltozero(item_price.column11) * percentage)/100)
    cust_price.column12 = (nulltozero(item_price.column12) - (nulltozero(item_price.column12) * percentage)/100)
    cust_price.column13 = (nulltozero(item_price.column13) - (nulltozero(item_price.column13) * percentage)/100)
    cust_price.column14 = (nulltozero(item_price.column14) - (nulltozero(item_price.column14) * percentage)/100)
    cust_price.column15 = (nulltozero(item_price.column15) - (nulltozero(item_price.column15) * percentage)/100)
    return cust_price
  end
  
  def self.set_nqp_column_price(cust_price,item_price)
    cust_price.column1 = nulltozero(item_price.column2)
    cust_price.column2 = nulltozero(item_price.column3)
    cust_price.column3 = nulltozero(item_price.column4)
    cust_price.column4 = nulltozero(item_price.column5)
    cust_price.column5 = nulltozero(item_price.column6)
    cust_price.column6 = nulltozero(item_price.column7)
    cust_price.column7 = nulltozero(item_price.column8)
    cust_price.column8 = nulltozero(item_price.column9)
    cust_price.column9 = nulltozero(item_price.column10)
    cust_price.column10 = nulltozero(item_price.column11)
    cust_price.column11 = nulltozero(item_price.column12)
    cust_price.column12 = nulltozero(item_price.column13)
    cust_price.column13 = nulltozero(item_price.column14)
    cust_price.column14 = nulltozero(item_price.column15)
    cust_price.column15 = nulltozero(item_price.column15)
    return cust_price
  end
end







