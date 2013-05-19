class Customer::CustomerContact < ActiveRecord::Base
  include UserStamp
  include Dbobject

  belongs_to :customer
  
  def add_line_errors_to_header
    
  end
end
