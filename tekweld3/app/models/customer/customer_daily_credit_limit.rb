class Customer::CustomerDailyCreditLimit < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  validates_uniqueness_of :credit_limit_date, :scope=>[:trans_flag,:customer_id]

  def add_line_errors_to_header

  end
end