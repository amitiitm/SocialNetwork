class Item::CatalogItemPackage < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
  
  def add_line_errors_to_header
    
  end
end
