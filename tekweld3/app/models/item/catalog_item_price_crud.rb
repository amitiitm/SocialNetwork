class Item::CatalogItemPriceCrud  < Crud
  include General
  
  def self.list_catalog_item_prices(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    Item::CatalogItemPrice.find(:all)  
  end
  
  def self.show_catalog_item_price(catalog_item_price_id)
    Item::CatalogItemPrice.find_all_by_id(catalog_item_price_id)
  end
  
  def self.create_catalog_item_prices(doc)
    catalog_item_prices = [] 
    (doc/:items/:item/:catalog_item_prices/:catalog_item_price).each{|catalog_item_price_doc|
      catalog_item_price = create_catalog_item_price(catalog_item_price_doc)
      catalog_item_prices <<  catalog_item_price if catalog_item_price
    }
    catalog_item_prices
  end

  def self.create_catalog_item_price(doc)
    catalog_item_price = add_or_modify_catalog_item_price(doc) 
    return  if !catalog_item_price
    save_proc = Proc.new{
      if catalog_item_price.new_record?
#        catalog_item_price.status = 'Successfully Updated'
        catalog_item_price.save!  
      else
        catalog_item_price.save! 
      end
    }
    if(catalog_item_price.errors.empty?)
      catalog_item_price.save_transaction(&save_proc)
    end
    return catalog_item_price
  end

  def self.add_or_modify_catalog_item_price(doc)
    #    status = parse_xml(doc/'status') if (doc/'status').first  
    #    update = parse_xml(doc/'update') if (doc/'update').first  
    #    if (update == 'YES')
    catalog_item_id =  parse_xml(doc/'catalog_item_id') if (doc/'catalog_item_id').first
    from_date =  parse_xml(doc/'from_date') if (doc/'from_date').first
    to_date =  parse_xml(doc/'to_date') if (doc/'to_date').first
    catalog_item_price = Item::CatalogItemPrice.find_or_create_by_catalog_item_id_and_from_date_and_to_date(catalog_item_id,from_date.to_date,to_date.to_date)
#    Item::CatalogItemPrice.delete_all(['catalog_item_id = ? ',catalog_item_id])
#    catalog_item_price = Item::CatalogItemPrice.new
    catalog_item_price.apply_attributes(doc)  
    return catalog_item_price 
    #    end
  end
  
end


