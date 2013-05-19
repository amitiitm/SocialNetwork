class Purchase::Purchaseperson < ActiveRecord::Base
include UserStamp
include Dbobject
include General

validates_presence_of :code
validates_uniqueness_of :code
def add_line_errors_to_header
end  
end
