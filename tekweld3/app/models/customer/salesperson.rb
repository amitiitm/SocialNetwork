class Customer::Salesperson < ActiveRecord::Base
#  include ContentModelMethods
#  include ClassMethods
  include UserStamp
  include Dbobject

  has_many :customers
end
