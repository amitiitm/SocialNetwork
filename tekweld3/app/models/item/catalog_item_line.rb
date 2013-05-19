class Item::CatalogItemLine < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
    
#  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
#updated on 27july
  belongs_to :catalog_item, :class_name => 'Item::CatalogItem', :foreign_key => "catalog_item_id"
  belongs_to :assemble_item, :class_name => 'Item::CatalogItem', :foreign_key => "assemble_item_id"
end
