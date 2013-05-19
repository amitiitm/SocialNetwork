class Crm::CrmContact < ActiveRecord::Base
include UserStamp
include Dbobject
include GenericSelects

belongs_to :crm_account
has_many :crm_addresses,:class_name =>'CrmAddress',:foreign_key => 'address_for_id', :dependent => :destroy, :extend=>ExtendAssosiation 
has_many :crm_accounts,:class_name =>'CrmAccount',:foreign_key => 'primary_contact_id', :dependent => :destroy, :extend=>ExtendAssosiation 

validates_numericality_of  :credit_limit, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
#validates_uniqueness_of :code 
  
def add_line_details(line_doc)
  id =  parse_xml(line_doc/'id') if (line_doc/'id').first
  line = crm_addresses.find_or_build(id) if line_doc.name == 'crm_address'
  line.apply_attributes(line_doc) if line
end
 
  
def add_line_errors_to_header
   add_line_item_errors(crm_addresses) if crm_addresses
 end

end
