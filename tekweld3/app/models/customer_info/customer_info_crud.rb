class CustomerInfo::CustomerInfoCrud < Crud
  include General
 
  def self.customer_open_memos(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_open_memo  
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}' ")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.customer_memos(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_all_memo  
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.customer_invoice_summary(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_invoice_summary 
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}' ")
    sql_query.commit_db_transaction 
    list    
  end
  
  def self.customer_invoice_by_item(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_invoice_by_item 
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.customer_credit_invoice_summary(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_credit_invoice_summary 
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list   
  end

  def self.customer_credit_invoice_by_item(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_credit_invoice_by_item  
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.customer_open_order(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_open_order  
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list 
  end
  
  def self.customer_orders(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_all_order  
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.top_sales(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_top_sales  
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.customer_open_receipts(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_open_receipt 
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list       
  end
  
  def self.customer_open_credits(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_open_credit 
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list  
  end
  
  def self.customer_receipts(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_all_receipt  
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.customer_credits(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_all_credit  
           '#{criteria.user_id}',
           '#{criteria.str1.to_i}',
           '#{criteria.dt1.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
           '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect1}'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.customer_aging(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_customer_info_aging
       '#{criteria.user_id}',
       '#{criteria.str1[0,8]}',
       'I',                               
       'D'   ")
    sql_query.commit_db_transaction 
    list
  end
  
end
