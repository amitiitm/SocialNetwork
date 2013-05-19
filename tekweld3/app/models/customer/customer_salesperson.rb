class Customer::CustomerSalesperson < ActiveRecord::Base
  include UserStamp
  include Dbobject

  belongs_to :customer
  belongs_to :salesperson
  
  def fill_default_detail_values
    
  end
end
