class Account::AccountYearCrud
include General
include ClassMethods
def self.list_account_years(doc)
  criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
  categories = Account::AccountYear.find(:all,
                                         :conditions=>["(year between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or year in ('#{criteria.multiselect1}'))) AND
                                                         account_years.description between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or account_years.description in ('#{criteria.multiselect2}'))
                                                        "
                                   
                                  ])
  categories                              
end

def self.show_account_year(account_id)
 Account::AccountYear.find_all_by_id(account_id)
end

def self.create_account_years(doc)
  accounts = [] 
 (doc/:account_years/:account_year).each{|acct_doc|
    account = create_account_year(acct_doc)
    accounts <<  account if account
  }
  accounts
end

def self.create_account_year(doc)
  account = add_or_modify_account_year(doc) 
  return  if !account
#  return account if !account.errors.empty?
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

def self.add_or_modify_account_year(doc)
  id =  parse_xml(doc/'id') if (doc/'id').first  
  account = Account::AccountYear.find_or_create(id) 
  return if !account
#  return account if account.view_only
  account.apply_attributes(doc)  
  account.build_lines(doc/:account_periods/:account_period)
#  account.run_block do
#    build_lines(doc/:account_periods/:account_period)
#  end
  account 
end
private_class_method :create_account_year, :add_or_modify_account_year
end

