class Customer::CustomerRelationship < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  
  belongs_to :customer,:class_name =>'Customer::Customer',:foreign_key => 'related_customer_id'

end
