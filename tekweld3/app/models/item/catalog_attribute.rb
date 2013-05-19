class Item::CatalogAttribute < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  validates :code, :presence => true
  validates_uniqueness_of :code, :message=>" is duplicate!!!"  
  validates_length_of :code, :maximum=>25, :allow_nil=>true ,:message=>" cannot be more than 25 chars"  
   
  has_many :catalog_attribute_values, :class_name => 'Item::CatalogAttributeValue' , :extend=>ExtendAssosiation

  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    #    fill_default_detail_values(line_doc) if (line_doc.name == 'catalog_attribute_value' and id.to_i > 0)
    line = catalog_attr_values(line_doc.name,id) ||nil
    #    line_lockversion = line.lock_version  
    line.apply_attributes(line_doc) if line
    #    line.lock_version = line_lockversion
    line
  end
  ## this function Not in USe
  def fill_default_detail_values(line_doc)
    code = parse_xml(line_doc/'code')
    setup_item_code = parse_xml(line_doc/'setup_item_code')
    setup_item_id = parse_xml(line_doc/'setup_item_id')
    setup_item_code2 = parse_xml(line_doc/'setup_item_code2')
    setup_item_id2 = parse_xml(line_doc/'setup_item_id2')
    invn_item_code = parse_xml(line_doc/'invn_item_code')
    invn_item_id = parse_xml(line_doc/'invn_item_id')
    attribute_values = Item::CatalogAttributeValue.active.find_all_by_code(code)
    attribute_values.each{|attribute_value|
      attribute_value.update_attributes!(:setup_item_code=>setup_item_code,:setup_item_id => setup_item_id,:setup_item_code2=>setup_item_code2,:setup_item_id2=>setup_item_id2,:invn_item_code=>invn_item_code,:invn_item_id=>invn_item_id)
    }
  end

  def catalog_attr_values(name,id)
    catalog_attribute_values.find_or_build(id) if name == 'catalog_attribute_value'
  end
 
  def save_lines
    catalog_attribute_values.save_line
  end

  def add_line_errors_to_header
    add_line_item_errors(catalog_attribute_values) if catalog_attribute_values
  end
  
end
