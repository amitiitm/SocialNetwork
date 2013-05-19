class Inventory::Labor < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods
  validates_uniqueness_of :code,:message=>'Already Exists'
  def fill_default_header_values
    self.trans_flag ||= 'A' 
  end
  def add_line_errors_to_header
    
  end
end
