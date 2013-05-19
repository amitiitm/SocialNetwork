class Customer::CustomerAsiranking < ActiveRecord::Base
  include UserStamp
  include Dbobject

  belongs_to :customer
  
end
