class Setup::ShippingCrud
  include General
  
  def self.list_shippings(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    Setup::Shipping.find_by_sql ["select CAST( (select(select id,code,name,phone,url from shippings
                                    where  (code between ? and ? AND (0 =? or code in (?))) AND
                                    (name between ? and ? AND (0=? or name in (?)))
                                    FOR XML PATH('shipping'),type,elements xsinil)FOR XML PATH('shippings')) AS xml) as xmlcol
      " ,
      criteria.str1,       criteria.str2,      criteria.multiselect1.length,criteria.multiselect1,
      criteria.str3,       criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,
    ]                                       
  end
  
  def self.show_shipping(shipping_id)
    Setup::Shipping.find_all_by_id(shipping_id)
  end
  
  def self.create_shippings(doc)
    shippings = [] 
    (doc/:shippings/:shipping).each{|shipping_doc|
      shipping = create_shipping(shipping_doc)
      shippings <<  shipping if shipping
    }
    shippings
  end

  def self.create_shipping(doc)
    shipping = add_or_modify(doc) 
    return  if !shipping
    save_proc = Proc.new{
      if shipping.new_record?
        shipping.save!  
      else
        shipping.save! 
      end
    }
    shipping.save_transaction(&save_proc)
    return shipping
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    shipping = Setup::Shipping.find_or_create(id) 
    return if !shipping
    shipping.apply_attributes(doc) 
    return shipping 
  end
  
end
