class Account::AccountPeriod < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  include General
  include ClassMethods
  belongs_to :account_year
  validates_presence_of :code,:period_flag ,:presence => true
  def add_line_errors_to_header
  end
end
