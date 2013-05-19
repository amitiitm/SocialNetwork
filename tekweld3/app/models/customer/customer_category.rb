class Customer::CustomerCategory < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods
  
  has_many :customers
  
  def add_line_errors_to_header
  end
end
