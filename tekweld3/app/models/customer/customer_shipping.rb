class Customer::CustomerShipping < ActiveRecord::Base
  include UserStamp
  include Dbobject

  belongs_to :customer, :class_name => 'Customer::Customer', :foreign_key => "customer_id"
  
 
end
