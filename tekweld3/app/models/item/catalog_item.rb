class Item::CatalogItem < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  
  validates :store_code, :web_code,  :presence => true
  validates_uniqueness_of :store_code, :web_code, :message=>" is duplicate!!!"  
  validates_length_of :store_code, :web_code, :maximum=>25, :allow_nil=>true ,:message=>" cannot be more than 25 chars"  
  has_many :catalog_item_packages, :class_name => 'Item::CatalogItemPackage' , :extend=>ExtendAssosiation
  has_many :catalog_item_setups, :class_name => 'Item::CatalogItemSetup' , :extend=>ExtendAssosiation
  has_many :catalog_item_accessories, :class_name => 'Item::CatalogItemAccessory' , :extend=>ExtendAssosiation
  has_many :catalog_group_items, :class_name => 'Item::CatalogGroupItem' , :extend=>ExtendAssosiation
  has_many :catalog_item_prices, :class_name => 'Item::CatalogItemPrice', :extend=>ExtendAssosiation
  has_many :catalog_item_lines, :class_name => 'Item::CatalogItemLine', :extend=>ExtendAssosiation
  has_many :catalog_item_packets, :class_name => 'Item::CatalogItemPacket', :extend=>ExtendAssosiation
  has_many :catalog_item_similar_items, :class_name => 'Item::CatalogItemSimilarItem', :extend=>ExtendAssosiation
  has_many :catalog_item_others, :class_name => 'Item::CatalogItemOther', :extend=>ExtendAssosiation
  has_many :catalog_item_images, :class_name => 'Item::CatalogItemImage', :extend=>ExtendAssosiation
  has_many :catalog_item_extensions, :class_name => 'Item::CatalogItemExtension', :extend=>ExtendAssosiation
  has_many :catalog_item_production_days, :class_name => 'Item::CatalogItemProductionDay' , :extend=>ExtendAssosiation
  #has_many :catalog_groups,:through => :catalog_group_items, :dependent => :destroy, :class_name => 'Item::CatalogGroup'
  belongs_to :catalog_item_category, :class_name => 'Item::CatalogItemCategory'
  belongs_to :company, :class_name => 'Setup::Company'
  has_many :catalog_item_workflows, :class_name => 'Item::CatalogItemWorkflow', :extend=>ExtendAssosiation
  has_many :catalog_item_attributes_values, :class_name => 'Item::CatalogItemAttributesValue' , :extend=>ExtendAssosiation
  has_many :catalog_attributes, :class_name => 'Item::CatalogAttribute' , :extend=>ExtendAssosiation
  has_many :catalog_attribute_values, :class_name => 'Item::CatalogAttributeValue' , :extend=>ExtendAssosiation
  has_many :catalog_item_price_levels, :class_name => 'Item::CatalogItemPriceLevel' , :extend=>ExtendAssosiation
  has_many :catalog_item_shippings, :class_name => 'Item::CatalogItemShipping' , :extend=>ExtendAssosiation
  has_many :catalog_item_templates, :class_name => 'Item::CatalogItemTemplate' , :extend=>ExtendAssosiation
  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = groups(line_doc.name,id) || item_prices(line_doc.name,id) || item_lines(line_doc.name,id)|| item_attributes_values(line_doc.name,id)|| item_similar_items(line_doc.name,id) || item_others(line_doc.name,id)||  item_images(line_doc.name,id) || item_extensions(line_doc.name,id) || setups(line_doc.name,id) || packages(line_doc.name,id) || item_price_levels(line_doc.name,id) || accessories(line_doc.name,id) || workflows(line_doc.name,id) || production_days(line_doc.name,id) || item_shippings(line_doc.name,id) || item_templates(line_doc.name,id) || nil
    temp_id_item_ext= line.id if (line_doc.name == 'catalog_item' and line.id.to_i >0)
    temp_lock_ver_item_ext = line.lock_version if(line_doc.name == 'catalog_item' and line.id.to_i >0)
    line.apply_attributes(line_doc) if line
    line.fill_default_detail_values if (line_doc.name == 'catalog_item_price')
    catalog_attribute_value_id=parse_xml(line_doc/'catalog_attribute_value_id').to_i  if (line_doc.name == 'catalog_item_attributes_value')
    line.catalog_attribute_value_id = catalog_attribute_value_id > 0 ? catalog_attribute_value_id:0  if (line_doc.name == 'catalog_item_attributes_value')
    line.id = temp_id_item_ext  if(line_doc.name == 'catalog_item' and line.id.to_i>0)
    line.lock_version = temp_lock_ver_item_ext if (line_doc.name == 'catalog_item' and line.id.to_i >0)
    line
  end
  
  
  def production_days(name,id)
    catalog_item_production_days.find_or_build(id) if name == 'catalog_item_production_day'
  end
  def accessories(name,id)
    catalog_item_accessories.find_or_build(id) if name == 'catalog_item_accessory'
  end
  def workflows(name,id)
    catalog_item_workflows.find_or_build(id) if name == 'catalog_item_workflow'
  end
  def setups(name,id)
    catalog_item_setups.find_or_build(id) if name == 'catalog_item_setup'
  end
  
  def packages(name,id)
    catalog_item_packages.find_or_build(id) if name == 'catalog_item_package'
  end
  
  def groups(name,id)
    catalog_group_items.find_or_build(id) if name == 'catalog_group'
  end
 
  def item_prices(name,id)
    catalog_item_prices.find_or_build(id) if name == 'catalog_item_price'
  end
 
  def item_lines(name,id)
    catalog_item_lines.find_or_build(id)  if name == 'catalog_item_line'
  end

  def item_attributes_values (name,id)
    catalog_item_attributes_values.find_or_build(id)  if name == 'catalog_item_attributes_value'
  end
 
  def item_similar_items(name,id)
    catalog_item_similar_items.find_or_build(id)  if name == 'catalog_item_similar_item'
  end
  
  def item_others(name,id)
    catalog_item_others.find_or_build(id)  if name == 'catalog_item_other'
  end
  
  def item_images(name,id)
    catalog_item_images.find_or_build(id)  if name == 'catalog_item_image'
  end
  
  def item_price_levels(name,id)
    catalog_item_price_levels.find_or_build(id)  if name == 'catalog_item_price_level'
  end

  def item_shippings(name,id)
    catalog_item_shippings.find_or_build(id)  if name == 'catalog_item_shipping'
  end

  def item_templates(name,id)
    catalog_item_templates.find_or_build(id)  if name == 'catalog_item_template'
  end
  
  def item_extensions(name,id)
    ext_id=0
    if ((id).to_i > 0 and id !=nil)
      #      id = catalog_item_extensions.find_by_catalog_item_id(id).id.to_s if name == 'catalog_item'
      extension=catalog_item_extensions.find_by_catalog_item_id(id) if name == 'catalog_item'
      ext_id = extension.id if extension
    end
    #    catalog_item_extensions.find_or_build(id) if name == 'catalog_item'  
    catalog_item_extensions.find_or_build(ext_id.to_s) if name == 'catalog_item'  
  end
 
  def save_lines
    catalog_group_items.save_line 
    catalog_item_prices.save_line 
    catalog_item_lines.save_line 
    catalog_item_attributes_values.save_line 
    catalog_item_similar_items.save_line 
    catalog_item_images.save_line 
    catalog_item_others.save_line 
    catalog_item_extensions.save_line
    catalog_item_setups.save_line
    catalog_item_packages.save_line
    catalog_item_price_levels.save_line
    catalog_item_accessories.save_line 
    catalog_item_workflows.save_line  
    catalog_item_production_days.save_line
    catalog_item_shippings.save_line
    catalog_item_templates.save_line
  end

  def add_line_errors_to_header
    add_line_item_errors(catalog_group_items) if catalog_group_items
    add_line_item_errors(catalog_item_prices) if catalog_item_prices
    add_line_item_errors(catalog_item_lines) if catalog_item_lines
    add_line_item_errors(catalog_item_attributes_values) if catalog_item_attributes_values
    add_line_item_errors(catalog_item_similar_items) if catalog_item_similar_items
    add_line_item_errors(catalog_item_others) if catalog_item_others
    add_line_item_errors(catalog_item_images) if catalog_item_images
    add_line_item_errors(catalog_item_extensions) if catalog_item_extensions
    add_line_item_errors(catalog_item_setups) if catalog_item_setups
    add_line_item_errors(catalog_item_packages) if catalog_item_packages
    add_line_item_errors(catalog_item_price_levels) if catalog_item_price_levels
    add_line_item_errors(catalog_item_accessories) if catalog_item_accessories
    add_line_item_errors(catalog_item_workflows) if catalog_item_workflows
    add_line_item_errors(catalog_item_production_days) if catalog_item_production_days
    add_line_item_errors(catalog_item_shippings) if catalog_item_shippings
    add_line_item_errors(catalog_item_templates) if catalog_item_templates
  end
 
end
