class Item::CatalogItemSetup < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
  belongs_to :setup_item, :class_name => 'Item::CatalogItem', :foreign_key => "setup_item_id"
  def add_line_errors_to_header
    
  end
end
