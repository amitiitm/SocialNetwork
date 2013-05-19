class Item::CatalogItemCategoryAttribute < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  
  belongs_to :catalog_item_category, :class_name => 'Item::CatalogItemCategory'
  belongs_to :catalog_attribute, :class_name => 'Item::CatalogAttribute'
  
end
