class Setup::Holiday < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  
  validates_uniqueness_of :holiday_date
  def add_line_errors_to_header
  end
end
