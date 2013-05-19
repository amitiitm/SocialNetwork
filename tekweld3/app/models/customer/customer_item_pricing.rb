class Customer::CustomerItemPricing < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
 
  belongs_to :customer, :class_name => 'Customer::Customer', :foreign_key => "customer_id"
  validates :catalog_item_id,:if=>Proc.new{|price| price.trans_flag=='A'},:uniqueness => {:scope => [:customer_id,:trans_flag],:message => "Already Exists For This Customer"}

  def fill_default_detail_values
    self.from_date = '2010-12-30 00:00:00.000'
    self.to_date = '2030-12-30 00:00:00.000'
  end

  def add_line_errors_to_header

  end
end
