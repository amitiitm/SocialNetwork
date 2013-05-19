class Item::CatalogItemAttributesValue < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :catalog_attribute, :class_name => 'Item::CatalogAttribute' , :extend=>ExtendAssosiation
  belongs_to :catalog_attribute_value, :class_name => 'Item::CatalogAttributeValue' , :extend=>ExtendAssosiation
  belongs_to :catalog_item, :class_name => 'Item::CatalogAttribute' , :extend=>ExtendAssosiation

  #  validates_uniqueness_of :catalog_attribute_value_id, :scope=>[:catalog_item_id,:catalog_attribute_id]
  validates :catalog_attribute_value_id,:if=>Proc.new{|value| value.trans_flag == 'A'},:uniqueness => {:scope => [:trans_flag,:catalog_item_id,:catalog_attribute_id],:message => "Attribute Already Exists For this Item"}
end
