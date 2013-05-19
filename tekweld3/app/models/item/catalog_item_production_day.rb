class Item::CatalogItemProductionDay < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
#  validates :catalog_item_id,:uniqueness => {:message => "Production Days Already Exists For this Item"}
  validates :catalog_item_id,:if=>Proc.new{|day| day.trans_flag == 'A'},:uniqueness => {:scope => [:trans_flag],:message => "Production Days Already Exists For this Item"}
  def add_line_errors_to_header
    
  end
end
