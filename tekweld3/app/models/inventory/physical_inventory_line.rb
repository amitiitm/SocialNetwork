class Inventory::PhysicalInventoryLine < ActiveRecord::Base
include UserStamp
include Dbobject
include General
include ClassMethods

  belongs_to :physical_inventory, :class_name => 'Inventory::PhysicalInventory'
  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
end
