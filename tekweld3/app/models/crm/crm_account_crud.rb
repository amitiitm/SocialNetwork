class Crm::CrmAccountCrud
include General

def self.list_categories(doc)
  criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
#  Crm::CrmAccountCategory.find_by_code_name_trans_flag(criteria)     
  Crm::CrmAccountCategory.find(:all,
                                :conditions => ["(code between ? and ? AND (0 =? or code in (?) ) ) AND
                                              (name between ? and ? AND (0 =? or name in (?) ) )
                                                " , criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
                                               criteria.str3, criteria.str4,criteria.multiselect2.length,criteria.multiselect2]                 
    )
end

def self.show_categories(category_id)
 Crm::CrmAccountCategory.find_all_by_id(category_id)
end

def self.create_categories(doc)
  categories = [] 
 (doc/:crm_account_categories/:crm_account_category).each{|acct_doc|
    category = create_category(acct_doc)
    categories <<  category if category
  }
  categories
end

def self.create_category(doc)
  category = add_or_modify_category(doc) 
  return  if !category
  return category if !category.errors.empty?
  save_proc = Proc.new{
     category.save! 
    }
 category.save_master(&save_proc)
 category
end

def self.add_or_modify_category(doc)
  id =  parse_xml(doc/'id') if (doc/'id').first  
  category = Crm::CrmAccountCategory.find_or_create(id) 
  return if !category
  return category if category.view_only
  category.apply_attributes(doc)  
  category 
end



def self.list_accounts(doc)
  criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  Crm::CrmAccount.active.find(:all,
                    :select=>'crm_accounts.*,crm_account_categories.code as crm_account_category_code,crm_contacts.first_name as crm_contact_name',
                    :joins=>'inner join crm_account_categories on crm_account_categories.id = crm_accounts.crm_account_category_id 
                    left outer join crm_contacts on crm_contacts.id = crm_accounts.primary_contact_id',
                    :conditions=>["(account_number between ? and ? AND (0 =? or account_number in (?))) AND
                                  (crm_account_category_id in (select id from crm_account_categories
                                        where code between ? and ? AND (0 =? or code in (?))))    AND
                                   (isnull(crm_accounts.name,'') between ? and ? AND (0 =? or crm_accounts.name in (?))) AND      
                                   (isnull(crm_accounts.account_source,'') between ? and ?) AND     
                                   (isnull(crm_accounts.prefered_contact_day,'') between ? and ?) AND  
                                   (isnull(crm_accounts.ownership_type,'')between ? and ?) AND  
                                   (isnull(crm_accounts.relationship_type,'') between ? and ?) AND  
                                   (isnull(crm_accounts.industry,'') between ? and ?) AND 
                                   (isnull(crm_accounts.account_rating,'') between ? and ?)                    
                                   ",
                                   criteria.str1, criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
                                   criteria.str3, criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
                                   criteria.str5, criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
                                   criteria.str7, criteria.str8,
                                   criteria.str9, criteria.str10,
                                   criteria.str11,criteria.str12,
                                   criteria.str13,criteria.str14,
                                   criteria.str15,criteria.str16,
                                   criteria.str17,criteria.str18
                                   
                                   
                                  ])
                                
end

def self.show_accounts(account_id)
 Crm::CrmAccount.find_by_id(account_id)
end

def self.create_accounts(doc)
  accounts = [] 
 (doc/:crm_accounts/:crm_account).each{|acct_doc|
    account = create_account(acct_doc)
    accounts <<  account if account
  }
  accounts
end

def self.create_account(doc)
    account = add_or_modify_account(doc) 
    return  if !account
    return account if !account.errors.empty?
    if account.new_record?
      code =  account.name.split(" ")[1] ? account.name.split(" ").first.first + account.name.split(" ")[1].first : account.name.split(" ").first.first 
      sequence_no = Crm::CrmLeadCrud.generate_docu_no('crm','crm',1)
      account_number = code + sequence_no if sequence_no
      Setup::Sequence.upd_book_code('crm','crm',sequence_no,1)
      account.account_number = account_number if account_number
    end
    save_proc = Proc.new{
      if account.new_record?
        account.save! 
      else
        account.save! 
        account.save_lines
      end
    }
    account.save_transaction(&save_proc)
    account
  end

  def self.add_or_modify_account(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    account = Crm::CrmAccount.find_or_create(id) 
    return if !account
    return account if account.view_only
    account.apply_attributes(doc)  
  
    account.run_block do
      build_lines(doc/:crm_addresses/:crm_address)
      build_lines(doc/:crm_tasks/:crm_task)
      build_lines(doc/:crm_contacts/:crm_contact)
      build_lines(doc/:crm_opportunities/:crm_opportunity)
      build_lines(doc/:crm_activities/:crm_activity)
    end
    account 
  end


end
