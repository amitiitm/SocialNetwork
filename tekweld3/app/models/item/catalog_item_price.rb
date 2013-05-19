class Item::CatalogItemPrice < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  #    attr_accessor  :status
  #    attr_accessor  :update
  attr_accessible :status
  attr_accessible :update
  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
#  validates :catalog_item_id,:uniqueness => {:message => "Price Already Exists For this Item"}
  validates :catalog_item_id,:if=>Proc.new{|price| price.trans_flag == 'A'},:uniqueness => {:scope => [:trans_flag],:message => "Price Already Exists For this Item"}
  def fill_default_detail_values
    self.from_date = '2010-12-30 00:00:00.000'
    self.to_date = '2030-12-30 00:00:00.000'
  end

  def add_line_errors_to_header
    
  end
  
end
