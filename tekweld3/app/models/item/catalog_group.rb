class Item::CatalogGroup < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  validates :code,  :presence => true
  validates_uniqueness_of :code, :message=>" is duplicate!!!"  
  validates_length_of :code, :maximum=>25, :allow_nil=>true ,:message=>" cannot be more than 25 chars"  
   
  has_many :catalog_group_items, :class_name => 'Item::CatalogGroupItem' , :extend=>ExtendAssosiation
  #has_many :catalog_items, :through => :catalog_group_items, :dependent => :destroy, :class_name => 'Item::CatalogItem'

 def add_line_details(line_doc)
  id =  parse_xml(line_doc/'id') if (line_doc/'id').first
  line = items(line_doc.name,id) ||nil
  line.apply_attributes(line_doc) if line
  line
 end

 def items(name,id)
   catalog_group_items.find_or_build(id) if name == 'catalog_item'
 end
 
 def save_lines
   catalog_group_items.save_line 
 end

 def add_line_errors_to_header
   add_line_item_errors(catalog_group_items) if catalog_group_items
 end
  
end
