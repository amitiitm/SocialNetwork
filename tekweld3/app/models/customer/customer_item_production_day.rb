class Customer::CustomerItemProductionDay < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :customer, :class_name => 'Customer::Customer', :foreign_key => "customer_id"
  #  validates_uniqueness_of :catalog_item_id, :scope => :customer_id,:message=>"Already Exist For this Customer"
  validates :catalog_item_id,:if=>Proc.new{|day| day.trans_flag == 'A'},:uniqueness => {:scope => [:customer_id,:trans_flag],:message => "Already Exists For this Item"}
  def add_line_errors_to_header
    
  end
end
