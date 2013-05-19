
class Crm::CrmAddressCrud
include General

def self.list_addresses(doc)
  criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  condition=" (nvl(address_for_flag,'') between ? and ? and (0 =? or address_for_flag in (?))) AND
                                    (address_name between ? and ? and (0 =? or address_name in (?))) AND
                                    (address_contact between ? and ? and (0 =? or address_contact in (?)))
                                    "
  condition=convert_sql_to_db_specific(condition)
  Crm::CrmAddress.active.find(:all,
                    :conditions=>[condition,
                                   criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
                                   criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
                                   criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3 
                                  ])
                                

end

def self.show_addresses(address_id)
 Crm::CrmAddress.find_all_by_id(address_id)
end

def self.create_addresses(doc)
  addresses = [] 
 (doc/:crm_addresss/:crm_address).each{|acct_doc|
    address = create_address(acct_doc)
    addresses <<  address if address
  }
  addresses
end

def self.create_address(doc)
  address = add_or_modify_address(doc) 
  return  if !address
  return address if !address.errors.empty?
  save_proc = Proc.new{
     address.save! 
    }
 address.save_master(&save_proc)
 address
end

def self.add_or_modify_address(doc)
  id =  parse_xml(doc/'id') if (doc/'id').first  
  address = Crm::CrmAddress.find_or_create(id) 
  return if !address
  return address if address.view_only
  address.apply_attributes(doc)  
  address 
end

end
