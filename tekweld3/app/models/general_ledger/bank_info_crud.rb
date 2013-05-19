class GeneralLedger::BankInfoCrud < Crud
  include General
 
  def self.bank_payment_info(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_bank_info_payment  
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}' ")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.bank_receipt_info(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_bank_info_receipt  
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.bank_transaction_info(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_bank_info_all_transaction 
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}' ")
    sql_query.commit_db_transaction 
    list    
  end
  
  def self.bank_balance_info(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_bank_info_date_summary 
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.bank_transfer_info(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_bank_info_transfer 
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list   
  end

 
end
