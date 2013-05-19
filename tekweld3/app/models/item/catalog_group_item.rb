class Item::CatalogGroupItem < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  
  belongs_to :catalog_group, :class_name => 'Catalog::CatalogGroup'
  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'

end
