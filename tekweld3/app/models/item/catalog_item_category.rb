class Item::CatalogItemCategory < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  
  has_many :catalog_items, :class_name => 'Item::CatalogItem' , :extend=>ExtendAssosiation
  has_many :catalog_item_category_attributes, :class_name => 'Item::CatalogItemCategoryAttribute' , :extend=>ExtendAssosiation


  validates :code,  :presence => true
  validates_uniqueness_of :code, :message=>" is duplicate!!!"  

  def add_line_details(line_doc)
  id =  parse_xml(line_doc/'id') if (line_doc/'id').first
  line = catalog_attributes(line_doc.name,id) ||nil
  line.apply_attributes(line_doc) if line
  line
 end

 def catalog_attributes(name,id)
   catalog_item_category_attributes.find_or_build(id) if name == 'catalog_item_category_attribute'
 end
 
 def save_lines
   catalog_item_category_attributes.save_line 
 end

 def add_line_errors_to_header
   add_line_item_errors(catalog_item_category_attributes) if catalog_item_category_attributes
 end
  
end
