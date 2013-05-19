class Account::AccountYear < ActiveRecord::Base
#include UserStamp
include Dbobject
include General
include GenericSelects
include ClassMethods
has_many :account_periods,:extend=>ExtendAssosiation
validates :year,:from_period,:to_period,:presence => true

def add_line_details(line_doc)
  id =  parse_xml(line_doc/'id') if (line_doc/'id').first
  line = accountperiodlines(line_doc.name,id) || nil
  line.apply_attributes(line_doc) if line
  
end
def accountperiodlines(name,id)
  account_periods.find_or_build(id) if name == 'account_period' 
end 
def save_lines 
  account_periods.save_line 
end

def add_line_errors_to_header
  add_line_item_errors(account_periods)
end
end
