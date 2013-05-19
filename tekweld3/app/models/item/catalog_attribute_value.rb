class Item::CatalogAttributeValue < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  
  belongs_to :catalog_attribute, :class_name => 'Catalog::CatalogAttribute'
#  validates_uniqueness_of :code, :scope=>[:catalog_attribute_id]
  validates :code,:if=>Proc.new{|value| value.trans_flag == 'A'},:uniqueness => {:scope => [:trans_flag,:catalog_attribute_id],:message => "Code Already Exists For this Item"}
  #  def fill_default_detail_values
  #    attribute_values = Item::CatalogAttributeValue.active.find_all_by_code(self.code)
  #    attribute_values.each{|attribute_value|
  #      attribute_value.update_attributes!(:setup_item_code=>self.setup_item_code,:setup_item_id => self.setup_item_id,:setup_item_code2=>self.setup_item_code2,:setup_item_id2=>self.setup_item_id2,:invn_item_code=>self.invn_item_code,:invn_item_id=>self.invn_item_id)
  #      #      self.setup_item_code = attribute_value.setup_item_code
  #      #      self.setup_item_id = attribute_value.setup_item_id
  #      #      self.setup_item_code2 = attribute_value.setup_item_code2
  #      #      self.setup_item_id2 = attribute_value.setup_item_id2
  #      #      self.invn_item_code = attribute_value.invn_item_code
  #      #      self.invn_item_id = attribute_value.invn_item_id
  #    }
  #  end
end
