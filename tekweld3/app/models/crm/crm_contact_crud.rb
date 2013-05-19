class Crm::CrmContactCrud
include General

#def self.list_contacts(doc)
#  criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
#  Crm::CrmContact.active.find(:all,
#                    :conditions=>[" 
#                                   (first_name between ? and ? AND (0 =? or first_name in (?))) AND
#                                    (last_name between ? and ? AND (0 =? or last_name in (?)))
#                                  ",criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
#                                    criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
#                                  ])
#                                
#end
# add new join to the sql

  def self.list_contacts(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Crm::CrmContact.active.find(:all,
      :joins => "left outer join crm_accounts on crm_accounts.id = crm_contacts.crm_account_id",
      :conditions=>[" (crm_contacts.first_name between ? and ? AND (0 =? or crm_contacts.first_name in (?))) AND
                      (crm_contacts.last_name between ? and ? AND (0 =? or crm_contacts.last_name in (?))) AND
                      (crm_accounts.account_number between ? and ? AND (0 =? or crm_accounts.account_number in (?))) AND
                      (crm_contacts.role between ? and ?)
                      
        ",criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
        criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
        criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
        criteria.str7,criteria.str8
      ],
                                
      :select => "crm_contacts.*,crm_accounts.name as account_number")
  end


def self.show_contacts(contact_id)
#  crm_contacts = []
#  crm_contacts << Crm::CrmContact.find_by_id(contact_id)
#  crm_addresses = []
#  crm_addresses = Crm::CrmAddress.find_all_by_address_for_flag_and_address_for_id('C',crm_contacts.id)
#  crm_contacts << crm_addresses 
#  crm_contacts
  Crm::CrmContact.find_by_id(contact_id)
end

def self.create_contacts(doc)
  contacts = [] 
 (doc/:crm_contacts/:crm_contact).each{|acct_doc|
    contact = create_contact(acct_doc)
    contacts <<  contact if contact
  }
  contacts
end

def self.create_contact(doc)
  contact = add_or_modify_contact(doc) 
  return  if !contact
  return contact if !contact.errors.empty?
  save_proc = Proc.new{
    if contact.new_record?
      contact.save! 
    else
      contact.save! 
      contact.crm_addresses.save_line
    end
     }
 contact.save_transaction(&save_proc)
 contact
end

def self.add_or_modify_contact(doc)
  id =  parse_xml(doc/'id') if (doc/'id').first  
  contact = Crm::CrmContact.find_or_create(id) 
  return if !contact
  return contact if contact.view_only
  contact.apply_attributes(doc)  
  contact.build_lines(doc/:crm_addresses/:crm_address)
  contact 
end

end


