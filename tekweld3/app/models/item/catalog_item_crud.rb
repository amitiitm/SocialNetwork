class Item::CatalogItemCrud
  include General

 
  #Item Category services  
  def self.list_catalog_item_categories(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    #    Item::CatalogItemCategory.find_by_code_name_trans_flag(criteria)
    Item::CatalogItemCategory.find(:all,
      :conditions => ["(code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or code in ('#{criteria.multiselect1}') ) ) AND
                       (name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or name in ('#{criteria.multiselect2}') ) )
        "]                 
    )
  end  

  def self.show_catalog_item_category(id)
    Item::CatalogItemCategory.find_all_by_id(id)
  end


  def self.list_catalog_item_category_attributes(id)
    Item::CatalogItemCategoryAttribute.find_all_by_catalog_item_category_id(id)
  end

  def self.create_catalog_item_categories(category_doc)
    catalog_item_categories = [] 
    (category_doc/:catalog_item_categories/:catalog_item_category).each{|doc|
      catalog_item_category = create_catalog_item_category(doc)
      catalog_item_categories <<  catalog_item_category if catalog_item_category
    }
    catalog_item_categories
  end

  def self.create_catalog_item_category(doc)
    catalog_item_category = add_or_modify_category(doc) 
    return  if !catalog_item_category
    save_proc = Proc.new{
      if catalog_item_category.new_record?
        catalog_item_category.save!  
      else
        catalog_item_category.save! 
        catalog_item_category.save_lines
      end
    }
    catalog_item_category.save_master(&save_proc)
    return  catalog_item_category
  end

  def self.add_or_modify_category(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    catalog_item_category = Item::CatalogItemCategory.find_or_create(id) 
    return if !catalog_item_category
    catalog_item_category.apply_attributes(doc) 
    # Add a block to set details
    catalog_item_category.run_block do
      build_lines(doc/:catalog_item_category_attributes/:catalog_item_category_attribute)
    end
    return catalog_item_category 
  end

  ## Item Service###
  def self.list_catalog_items(doc) ## used in tekweld
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(store_code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or store_code in ('#{criteria.multiselect1}') )) AND
                 (catalog_items.name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or catalog_items.name in ('#{criteria.multiselect2}'))) AND
                 (item_type between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} or item_type in ('#{criteria.multiselect3}') )) AND
                 (catalog_item_categories.code between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} or catalog_item_categories.code in ('#{criteria.multiselect4}') )) AND
                 (catalog_items.workflow between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} or catalog_items.workflow in ('#{criteria.multiselect5}')))"
    condition = convert_sql_to_db_specific(condition)
    Item::CatalogItem.find_by_sql ["select CAST(( 
                                  select(select catalog_items.*
                                  from catalog_items
                                  inner join catalog_item_categories on catalog_item_categories.id = catalog_items.catalog_item_category_id
                                  where #{condition}
                                  FOR XML PATH('catalog_item'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('catalog_items')) AS varchar(MAX)) as catalog_items "
    ]
  end
  def self.show_catalog_item(catalog_item_id) ## used in tekweld
    #    Item::CatalogItem.find_all_by_id(catalog_item_id) #active removed on 8 jun
    Item::CatalogItem.where(:id => catalog_item_id)
  end
  
  def self.show_catalog_item_with_price(item_id,trans_date)
    Item::CatalogItem.find_by_sql ["SELECT catalog_items.id as catalog_item_id,catalog_items.store_code as store_code,catalog_items.web_code as web_code,catalog_items.name as name,catalog_items.image_thumnail as image_thumnail,
                              catalog_items.purchase_description as purchase_description, catalog_items.sale_description as sale_description, catalog_items.taxable, catalog_items.packet_require_yn,
                              catalog_item_prices.price as price,
                              catalog_items.item_type, catalog_items.cost as cost
                              FROM catalog_items  
                              left outer join catalog_item_prices 
                              on catalog_items.id = catalog_item_prices.catalog_item_id and
                                      ( ? between from_date and to_date)
                              WHERE (catalog_items.trans_flag = 'A') AND 
                              ((catalog_items.id between ? and ? ) 
                              )",trans_date,item_id,item_id ]
  end

  def self.create_catalog_items(doc) ## used in tekweld
    catalog_items = []
    (doc/:catalog_items/:catalog_item).each{|catalog_item_doc|
      catalog_item = create_catalog_item(catalog_item_doc)
      catalog_items <<  catalog_item if catalog_item
    }
    catalog_items
  end

  def self.create_catalog_item(doc) ## used in tekweld
    catalog_item = add_or_modify_item(doc)
    return  if !catalog_item
#    is_item_in_open_orders(catalog_item) if !catalog_item.new_record?
    save_proc = Proc.new{
      if catalog_item.new_record?
        catalog_item.save!
      else
        catalog_item.save!
        catalog_item.save_lines
      end
    }
    if(catalog_item.errors.empty?)
      catalog_item.save_transaction(&save_proc)
    end
    return catalog_item
  end

  def self.add_or_modify_item(doc) ## used in tekweld
    id =  parse_xml(doc/'id') if (doc/'id').first
    catalog_item = Item::CatalogItem.find_or_create(id)
    return if !catalog_item
    catalog_item.apply_attributes(doc)
    catalog_item.meta_tag= build_meta_tag(doc)
    ## Function Called to make different XML for catalog_item_attributes_values(ciav)
    ciav_xml = create_ciav_xml(doc/:catalog_item_attributes_values/:catalog_item_attributes_value)
    # Add a block to set details
    catalog_item.run_block do
      #      build_lines(doc/:catalog_groups/:catalog_group)
      build_lines(doc/:catalog_item_prices/:catalog_item_price)
      build_lines(doc/:catalog_item_lines/:catalog_item_line)
      build_lines(ciav_xml/:catalog_item_attributes_value) ## newly added to build ciav
      build_lines(doc/:catalog_item_similar_items/:catalog_item_similar_item)
      #      build_lines(doc/:catalog_item_others/:catalog_item_other)
      #      build_lines(doc/:catalog_item_images/:catalog_item_image)
      build_lines(doc/:catalog_item_packages/:catalog_item_package)
      build_lines(doc/:catalog_item_setups/:catalog_item_setup)
      build_lines(doc/:catalog_item_price_levels/:catalog_item_price_level)
      build_lines(doc/:catalog_item_accessories/:catalog_item_accessory)
      #      build_lines(doc/:catalog_item_workflows/:catalog_item_workflow)
      build_lines(doc/:catalog_item_production_days/:catalog_item_production_day)
      build_lines(doc/:catalog_item_shippings/:catalog_item_shipping)
      build_lines(doc/:catalog_item_templates/:catalog_item_template)
      catalog_item.add_line_details(doc)
    end
    return catalog_item
  end
  ## NEW Function to make different XML for catalog_item_attributes_values which saves all attributes without having attribute_value selected used in tekweld
  def self.create_ciav_xml(ci_attributes_value_doc)
    xml_string = "<catalog_item_attributes_values>"
    seq_no = 1
    
    ci_attributes_value_doc.each{|ci_attribute_value_doc|
      only_attribute = true ## this will show that the xml contains only attributes and no values
      catalog_attribute_id = parse_xml(ci_attribute_value_doc/'catalog_attribute_id')
      trans_flag = parse_xml(ci_attribute_value_doc/'trans_flag1') || 'A'
      (ci_attribute_value_doc/:attribute_values/:attribute_value).each{|attribute_value|
        catalog_attribute_value_id = parse_xml(attribute_value/'catalog_attribute_value_id')
        id = parse_xml(attribute_value/'id')
        update_flag = parse_xml(attribute_value/'update_flag') || 'Y'
        attribute_value_trans_flag = parse_xml(attribute_value/'trans_flag') || 'A'
        lock_version = parse_xml(attribute_value/'lock_version') || 0
        default_value = parse_xml(attribute_value/'default_value')
        xml_string = xml_string+"<catalog_item_attributes_value>"
        xml_string = xml_string +"<catalog_attribute_id>#{catalog_attribute_id}</catalog_attribute_id>"
        xml_string = xml_string +"<catalog_attribute_value_id>#{catalog_attribute_value_id}</catalog_attribute_value_id>"
        xml_string = xml_string +"<id>#{id}</id>"
        xml_string = xml_string +"<update_flag>#{update_flag}</update_flag>"
        if trans_flag == 'D'
          xml_string = xml_string +"<trans_flag>#{trans_flag}</trans_flag>"
        else
          xml_string = xml_string +"<trans_flag>#{attribute_value_trans_flag}</trans_flag>"
        end
        xml_string = xml_string +"<default_value>#{default_value}</default_value>"
        xml_string = xml_string +"<lock_version>#{lock_version}</lock_version>"
        xml_string = xml_string +"<seq_no>#{seq_no}</seq_no>"
        xml_string = xml_string+"</catalog_item_attributes_value>"
        only_attribute = false
      }
      if only_attribute == true
        xml_string = xml_string + "<catalog_item_attributes_value>"
        xml_string = xml_string +"<catalog_attribute_id>#{catalog_attribute_id}</catalog_attribute_id>"
        xml_string = xml_string +"<trans_flag>#{trans_flag}</trans_flag>"
        xml_string = xml_string +"<update_flag>Y</update_flag>"
        xml_string = xml_string +"<lock_version>0</lock_version>"
        xml_string = xml_string +"<seq_no>#{seq_no}</seq_no>"
        xml_string = xml_string + "</catalog_item_attributes_value>"
      end
      seq_no = seq_no + 1
    }
    xml_string = xml_string+"</catalog_item_attributes_values>"
    puts xml_string
    xml = %{#{xml_string}}
    doc = Hpricot::XML(xml)
    return doc
  end

  def self.is_item_in_open_orders(catalog_item)
    open_orders_count = Sales::SalesOrder.find_by_sql ["select COUNT(sol.id) as total_open_orders from sales_order_lines sol
                                                      inner join sales_orders so on so.id = sol.sales_order_id
                                                      where sol.trans_flag = 'A' and sol.item_type = 'I' and
                                                            so.shipped_flag = 'N' and sol.catalog_item_id = #{catalog_item.id}"]
    if open_orders_count[0].total_open_orders != 0
      catalog_item.errors[:base] << "This Item Cannot be Updated, Because There are Open Orders Containing Item #{catalog_item.store_code}.Once Orders are Completed You Can Change the Item"
    end
  end
  #### This Function is working fine but due to some new changes like catalog_attribute_value_id can be blank in table CIAV and
  #we have to save attributes even if no values are selected.
  #  ## Function to make different XML for catalog_item_attributes_values used in tekweld
  #  def self.create_ciav_xml(ci_attributes_value_doc)
  #    xml_string = "<catalog_item_attributes_values>"
  #    seq_no = 1
  #    ci_attributes_value_doc.each{|ci_attribute_value_doc|
  #      catalog_attribute_id = parse_xml(ci_attribute_value_doc/'catalog_attribute_id')
  #      trans_flag = parse_xml(ci_attribute_value_doc/'trans_flag1') || 'A'
  #      (ci_attribute_value_doc/:attribute_values/:attribute_value).each{|attribute_value|
  #        catalog_attribute_value_id = parse_xml(attribute_value/'catalog_attribute_value_id')
  #        id = parse_xml(attribute_value/'id')
  #        update_flag = parse_xml(attribute_value/'update_flag') || 'Y'
  #        attribute_value_trans_flag = parse_xml(attribute_value/'trans_flag') || 'A'
  #        lock_version = parse_xml(attribute_value/'lock_version') || 0
  #        default_value = parse_xml(attribute_value/'default_value')
  #        xml_string = xml_string+"<catalog_item_attributes_value>"
  #        xml_string = xml_string +"<catalog_attribute_id>#{catalog_attribute_id}</catalog_attribute_id>"
  #        xml_string = xml_string +"<catalog_attribute_value_id>#{catalog_attribute_value_id}</catalog_attribute_value_id>"
  #        xml_string = xml_string +"<id>#{id}</id>"
  #        xml_string = xml_string +"<update_flag>#{update_flag}</update_flag>"
  #        if trans_flag == 'D'
  #          xml_string = xml_string +"<trans_flag>#{trans_flag}</trans_flag>"
  #        else
  #          xml_string = xml_string +"<trans_flag>#{attribute_value_trans_flag}</trans_flag>"
  #        end
  #        xml_string = xml_string +"<default_value>#{default_value}</default_value>"
  #        xml_string = xml_string +"<lock_version>#{lock_version}</lock_version>"
  #        xml_string = xml_string +"<seq_no>#{seq_no}</seq_no>"
  #        xml_string = xml_string+"</catalog_item_attributes_value>"
  #      }
  #      seq_no = seq_no + 1
  #    }
  #    xml_string = xml_string+"</catalog_item_attributes_values>"
  #    xml = %{#{xml_string}}
  #    doc = Hpricot::XML(xml)
  #    return doc
  #  end
  #build meta tag service
  def self.build_meta_tag(doc) ## used in tekweld
    store_code= web_code= sale_description =purchase_description =name =catalog_item_category_code= ''
    store_code =  parse_xml(doc/'store_code') if (doc/'store_code').first
    web_code =  parse_xml(doc/'web_code') if (doc/'web_code').first
    sale_description =  parse_xml(doc/'sale_description') if (doc/'sale_description').first
    purchase_description =  parse_xml(doc/'purchase_description') if (doc/'purchase_description').first
    name =  parse_xml(doc/'name') if (doc/'name').first
    catalog_item_category_id=parse_xml(doc/'catalog_item_category_id') if (doc/'catalog_item_category_id').first
    catalog_item_category_obj=Item::CatalogItemCategory.find_by_id(catalog_item_category_id)
    catalog_item_category_code=catalog_item_category_obj.code
    attribute_name=''
    (doc/:catalog_item_attributes_values/:catalog_item_attributes_value).each{|catalog_item_doc|
      attribute_name= attribute_name + ' ' + parse_xml(catalog_item_doc/'attribute_name') if (catalog_item_doc/'attribute_name')
    }
    #   attribute_name=parse_xml(doc/:catalog_item_attributes_values/:catalog_item_attributes_value/'attribute_name') if (doc/:catalog_item_attributes_values/:catalog_item_attributes_value/'attribute_name').first
    meta_tag= store_code +' and ' + web_code +' and ' + name +' and ' + sale_description + ' and ' + purchase_description + 'and ' + attribute_name + ' and ' +  catalog_item_category_code
    return meta_tag
  end
  
  #Group Services
  def self.list_catalog_groups(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    Item::CatalogGroup.find_by_code_name_trans_flag(criteria)
  end

  def self.show_catalog_group(catalog_group_id)
    Item::CatalogGroup.active.find_all_by_id(catalog_group_id)
  end
  
  def self.create_catalog_groups(doc)
    catalog_groups = []
    (doc/:catalog_groups/:catalog_group).each{|catalog_group_doc|
      catalog_group = create_catalog_group(catalog_group_doc)
      catalog_groups <<  catalog_group if catalog_group
    }
    catalog_groups
  end

  def self.create_catalog_group(doc)
    catalog_group = add_or_modify_group(doc)
    return  if !catalog_group
    save_proc = Proc.new{
      if catalog_group.new_record?
        catalog_group.save!
      else
        catalog_group.save!
        catalog_group.save_lines
      end
    }
    catalog_group.save_transaction(&save_proc)
    return catalog_group
  end

  def self.add_or_modify_group(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    catalog_group = Item::CatalogGroup.find_or_create(id)
    return if !catalog_group
    catalog_group.apply_attributes(doc)
    catalog_group.run_block do
      build_lines(doc/:catalog_items/:catalog_item)
    end
    return catalog_group
  end

  #Attribute Services
  def self.list_catalog_attributes(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    #    Item::CatalogAttribute.find_by_code_name_trans_flag(criteria)
    Item::CatalogAttribute.find(:all,
      :conditions => ["(code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or code in ('#{criteria.multiselect1}') ) ) AND
                       (name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or name in ('#{criteria.multiselect2}') ) )
        " ]
    )
  end

  def self.show_catalog_attribute(catalog_attribute_id)
    #    Item::CatalogAttribute.find_all_by_id(catalog_attribute_id)
    Item::CatalogAttribute.where(:id => catalog_attribute_id)
  end
  
  def self.create_catalog_attributes(doc)
    catalog_attributes = []
    (doc/:catalog_attributes/:catalog_attribute).each{|catalog_attribute_doc|
      catalog_attribute = create_catalog_attribute(catalog_attribute_doc)
      catalog_attributes <<  catalog_attribute if catalog_attribute
    }
    catalog_attributes
  end

  def self.create_catalog_attribute(doc)
    catalog_attribute = add_or_modify_attribute(doc)
    return  if !catalog_attribute
    save_proc = Proc.new{
      if catalog_attribute.new_record?
        catalog_attribute.save!
      else
        catalog_attribute.save!
        catalog_attribute.save_lines
      end
    }
    catalog_attribute.save_transaction(&save_proc)
    return catalog_attribute
  end

  def self.add_or_modify_attribute(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    catalog_attribute = Item::CatalogAttribute.find_or_create(id)
    return if !catalog_attribute
    catalog_attribute.apply_attributes(doc)
    catalog_attribute.run_block do
      build_lines(doc/:catalog_attribute_values/:catalog_attribute_value)
    end
    return catalog_attribute
  end


  def self.search_catalog_items(meta_tag)
    Item::CatalogItem.find_by_sql ["select * from catalog_items where meta_tag like ?",'%'+meta_tag+'%']
  end
  ## this service is used in tekweld for fetching customer specific setup item price defined on item options value.
  def self.fetch_setup_charge_for_item_option_value(attribute_code_id,catalog_attribute_value_code,customer_id)
    catalog_attribute_value = Item::CatalogAttributeValue.active.find_by_code_and_catalog_attribute_id(catalog_attribute_value_code,attribute_code_id)
    if (catalog_attribute_value and catalog_attribute_value.setup_item_id and catalog_attribute_value.setup_item_id != '')
      catalog_item,customer_specific_price = Item::PriceUtility.fetch_cust_specific_price(catalog_attribute_value.setup_item_id,customer_id)
      return catalog_item,customer_specific_price
    else
      catalog_item = []
      return catalog_item,customer_specific_price
    end
  end
  def self.fetch_setup_charge_for_item_option_value2(attribute_code_id,catalog_attribute_value_code,customer_id)
    catalog_attribute_value = Item::CatalogAttributeValue.active.find_by_code_and_catalog_attribute_id(catalog_attribute_value_code,attribute_code_id)
    if (catalog_attribute_value and catalog_attribute_value.setup_item_id2 and catalog_attribute_value.setup_item_id2 != '')
      catalog_item,customer_specific_price = Item::PriceUtility.fetch_cust_specific_price(catalog_attribute_value.setup_item_id2,customer_id)
      return catalog_item,customer_specific_price
    else
      catalog_item = []
      return catalog_item,customer_specific_price
    end
  end

  ## this service is used in tekweld for fetching customer specific setup item price defined on item options value.
  def self.fetch_setup_charge_for_item_option_code(catalog_attribute_code,customer_id)
    catalog_attribute = Item::CatalogAttribute.find_by_code(catalog_attribute_code)
    if (catalog_attribute and catalog_attribute.setup_item_id and catalog_attribute.setup_item_id != '')
      catalog_item,customer_specific_price = Item::PriceUtility.fetch_cust_specific_price(catalog_attribute.setup_item_id,customer_id)
      return catalog_item,customer_specific_price
    else
      catalog_item = []
      return catalog_item,customer_specific_price
    end
  end

  def self.fetch_setup_charge_for_item_option_code2(catalog_attribute_code,customer_id)
    catalog_attribute = Item::CatalogAttribute.find_by_code(catalog_attribute_code)
    if (catalog_attribute and catalog_attribute.setup_item_id2 and catalog_attribute.setup_item_id2 != '')
      catalog_item,customer_specific_price = Item::PriceUtility.fetch_cust_specific_price(catalog_attribute.setup_item_id2,customer_id)
      return catalog_item,customer_specific_price
    else
      catalog_item = []
      return catalog_item,customer_specific_price
    end
  end
  
  def self.catalog_attribute_value_lookup
    list = Item::CatalogAttributeValue.find_by_sql ["select id, code, name, catalog_attribute_id from catalog_attribute_values
                                    where trans_flag ='A'    "
    ]
    list
  end
  
  def self.attribute_details(attr_id,attr_code)
    attribute = Item::CatalogAttribute.find_all_by_id_and_code(attr_id,attr_code)
    attribute
  end

  def self.upload_item_templates(uploaded_file,schema_name)
    begin
      file_name,folder_name = IO::FileIO.save_item_templates(uploaded_file,schema_name)
    rescue Exception => ex
      puts "************Exception-- #{ex},File Name--#{file_name},Folder Name--#{folder_name}********"
      return 'error'
    end
    return 'success'
  end
end
