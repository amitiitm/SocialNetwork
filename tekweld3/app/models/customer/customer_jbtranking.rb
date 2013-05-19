class Customer::CustomerJbtranking < ActiveRecord::Base
  include UserStamp
  include Dbobject

  belongs_to :customer
  
end
