class Setup::AccountYear < ActiveRecord::Base
  include UserStamp
  include Dbobject
  
  has_many:account_periods
  validates_uniqueness_of :year
end
