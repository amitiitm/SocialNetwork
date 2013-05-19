class Item::CatalogItemWorkflow < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
    

  belongs_to :catalog_item, :class_name => 'Item::CatalogItem', :foreign_key => "catalog_item_id"
end
