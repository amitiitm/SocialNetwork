class Item::CatalogItemTemplate  < ActiveRecord::Base
 include UserStamp
 include Dbobject
 include GenericSelects

  belongs_to :catalog_item, :class_name => 'Item::CatalogItem', :foreign_key => "catalog_item_id"
  validates :imprint_type_code,:if=>Proc.new{|value| value.trans_flag == 'A'},:uniqueness => {:scope => [:trans_flag,:catalog_item_id],:message => "Imprint Type Already Exists For this Item"}
end
