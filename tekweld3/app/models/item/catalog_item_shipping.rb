class Item::CatalogItemShipping  < ActiveRecord::Base
 include UserStamp
 include Dbobject
 include GenericSelects

  belongs_to :catalog_item, :class_name => 'Item::CatalogItem', :foreign_key => "catalog_item_id"
  validates_uniqueness_of :imprint_type_code, :scope=>[:catalog_item_id]
end
