class Customer::CustomerContactCrud < Crud
  include General
  
  def self.list_contacts(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Customer::CustomerContact.find_by_sql ["select CAST( (select(select customer_contacts.id,customer_contacts.first_name,customer_contacts.last_name,
                                            customer_contacts.job_title,customer_contacts.department,customer_contacts.gender,customer_contacts.date_of_birth,
                                            customer_contacts.manager,customer_contacts.role,customer_contacts.address1,customer_contacts.address2,
                                            customer_contacts.city,customer_contacts.state,customer_contacts.country,customer_contacts.business_phone,
                                            customer_contacts.email,customers.code as customer_code from customer_contacts 
                                            inner join customers on customers.id = customer_contacts.customer_id 
                                            where
                                            (customer_contacts.trans_flag = 'A') AND
                                            (customer_contacts.first_name between ? and ? AND (0 =? or customer_contacts.first_name in (?))) AND
                                            (customer_contacts.last_name between ? and ? AND (0 =? or customer_contacts.last_name in (?))) AND
                                            (customers.code between ? and ? AND (0 =? or customers.code in (?))) AND
                                            (customer_contacts.role between ? and ?)
                                            FOR XML PATH('customer_contact'),type,elements xsinil)FOR XML PATH('customer_contacts')) AS xml) as xmlcol ",
      criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
      criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
      criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
      criteria.str7,criteria.str8
    ] 
  end


  def self.show_contacts(contact_id)
    Customer::CustomerContact.find_all_by_id(contact_id)
  end

  def self.create_contacts(doc)
    contacts = [] 
    (doc/:customer_contacts/:customer_contact).each{|acct_doc|
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
      contact.save! 
    }
    contact.save_transaction(&save_proc)
    contact
  end

  def self.add_or_modify_contact(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    contact = Customer::CustomerContact.find_or_create(id) 
    return if !contact
    contact = add_default_contact(doc,contact)
    contact.apply_attributes(doc)  
    contact 
  end

  def self.add_default_contact(doc,contact)
    customer_id =  parse_xml(doc/'customer_id') if (doc/'customer_id').first 
    customer_contact = Customer::CustomerContact.find_by_customer_id_and_trans_flag(customer_id,'A')
    if customer_contact
      return contact
    else
      contact.default_contact_flag = 'Y'
      return contact
    end
  end

end