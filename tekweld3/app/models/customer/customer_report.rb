class Customer::CustomerReport < ActiveRecord::Base  
  include General
  
  def self.invoice_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_customer_invoice_register
                                                          #{criteria.user_id},
                                                          '#{criteria.str1[0,8]}', '#{criteria.str2[0,8]}', '#{criteria.multiselect1}',
                                                          '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
                                                          '#{criteria.str3}',      '#{criteria.str4}',      '#{criteria.multiselect2}',
                                                          '#{criteria.str5}',      '#{criteria.str6}',      '#{criteria.multiselect3}',
                                                          '#{criteria.str7}',      '#{criteria.str8}',      '#{criteria.multiselect4}',
                                                          '#{criteria.str9}',      '#{criteria.str10}',     '#{criteria.multiselect5}',
                                                          '#{criteria.str11}',     '#{criteria.str12}',     '#{criteria.multiselect6}',
                                                          '#{criteria.str13[0,4]}', '#{criteria.str14[0,4]}',      '#{criteria.multiselect7}',
                                                          '#{criteria.str15}',      '#{criteria.str16}',  '#{criteria.multiselect8}',
                                                          '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
                                                          '#{criteria.str17}',      '#{criteria.str18}',    '#{criteria.multiselect9}'")
    sql_query.commit_db_transaction
    list[0]['xmlcol']
  end

  def self.receipt_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_customer_receipt_register
                                                          #{criteria.user_id},
                                                          '#{criteria.str1[0,8]}', '#{criteria.str2[0,8]}', '#{criteria.multiselect1}',
                                                          '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
                                                          '#{criteria.str3}',      '#{criteria.str4}',      '#{criteria.multiselect2}',
                                                          '#{criteria.str5}',      '#{criteria.str6}',      '#{criteria.multiselect3}',
                                                          '#{criteria.str7}',      '#{criteria.str8}',      '#{criteria.multiselect4}',
                                                          '#{criteria.str9}',      '#{criteria.str10}',     '#{criteria.multiselect5}',
                                                          '#{criteria.str11}',     '#{criteria.str12}',     '#{criteria.multiselect6}',
                                                          '#{criteria.str13}',     '#{criteria.str14}',     '#{criteria.multiselect7}',
                                                          '#{criteria.str15}',     '#{criteria.str16}',     '#{criteria.multiselect8}',
                                                          '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
                                                          '#{criteria.str17}',     '#{criteria.str18}',     '#{criteria.multiselect9}',
                                                          0, 9999999, '#{criteria.multiselect10}',
                                                          '#{criteria.str21}',     '#{criteria.str22}',     '#{criteria.multiselect11}'")
    sql_query.commit_db_transaction
    list[0]['xmlcol']
  end

  def self.credit_invoice_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_customer_credit_invoice_register
                                                          #{criteria.user_id},
                                                          '#{criteria.str1[0,8]}', '#{criteria.str2[0,8]}', '#{criteria.multiselect1}',
                                                          '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
                                                          '#{criteria.str3}',      '#{criteria.str4}',      '#{criteria.multiselect2}',
                                                          '#{criteria.str5}',      '#{criteria.str6}',      '#{criteria.multiselect3}',
                                                          '#{criteria.str7}',      '#{criteria.str8}',      '#{criteria.multiselect4}',
                                                          '#{criteria.str9}',      '#{criteria.str10}',     '#{criteria.multiselect5}',
                                                          '#{criteria.str11}',     '#{criteria.str12}',     '#{criteria.multiselect6}',
                                                          '#{criteria.str13}',     '#{criteria.str14}',     '#{criteria.multiselect7}',
                                                          '#{criteria.str15}',      '#{criteria.str16}',    '#{criteria.multiselect8}',
                                                          '#{criteria.str17}',      '#{criteria.str18}',    '#{criteria.multiselect9}',
                                                          '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
                                                          '#{criteria.str19}',      '#{criteria.str20}',    '#{criteria.multiselect10}'")
    sql_query.commit_db_transaction
    list[0]['xmlcol']
  end
 
  #Master method for calculating aging
  #  def self.customer_aging_detail(doc)   
  #  criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #  mstr_aging_table = []  
  #  if(criteria.str7 == '' or criteria.str7 == nil)
  #      criteria.str7 = criteria.str8
  #  end 
  #  if(criteria.dt1.to_date.to_s == '1990-01-01')
  #     criteria.dt1 = criteria.dt2     
  #  end
  #  if(criteria.str7 != '' and criteria.str7 != 'zzzz')
  #    ac_period_obj = Setup::AccountPeriod.find_by_sql(["select to_date as to_dt from account_periods where code = ? ",criteria.str7 ])
  #    criteria.dt1 = ac_period_obj.first.to_dt if ac_period_obj.first   
  #  end   
  #  
  #  invoices = customer_invoices(criteria)                      
  #  aging_invoices = customer_invoices_aging(invoices,criteria.dt1)
  #  aging_invoices.each { |i|
  #         mstr_aging_table << i  } 
  # 
  #  receipts = customer_receipts(criteria)                      
  #  aging_receipts =  customer_receipts_aging(receipts,criteria.dt1)
  #  aging_receipts.each { |i|
  #         mstr_aging_table << i  } 
  #       
  #  mstr_aging_table
  #end
  #
  #  #to list invoices for aging
  # def self.customer_invoices(criteria)
  #   condition="customer_invoices.company_id in(select company_id from user_companies where user_id=?) AND
  #                              (customer_categories.code between ? and ? and (0 = ? or customer_categories.code in (?))) AND 
  #                              (customers.code between ? and ? and (0 = ? or customers.code in (?))) AND
  #                              (customers.salesperson_code between ? and ? and (0 = ? or customers.salesperson_code in (?))) AND
  #                              (customer_invoices.trans_date <= ?) AND       
  #                              (customer_invoices.account_period_code <= nvl(rtrim(ltrim(?)),customer_invoices.account_period_code)) AND
  #                              (customer_invoices.trans_flag = 'A') "
  #   condition = convert_sql_to_db_specific(condition)
  #   Customer::CustomerInvoice.find(:all,
  #                  :joins =>" inner join customers  on customers.id = customer_invoices.customer_id 
  #                             inner join customer_categories on customer_categories.id = customers.customer_category_id 
  #                             inner join companies on companies.id = customer_invoices.company_id",
  #                  :conditions =>[condition,
  #                              criteria.user_id,
  #                              criteria.str1,criteria.str2,  criteria.multiselect1.length, criteria.multiselect1,
  #                              criteria.str3,criteria.str4,  criteria.multiselect2.length, criteria.multiselect2,
  #                              criteria.str5,criteria.str6,  criteria.multiselect3.length, criteria.multiselect3,
  #                              criteria.dt1,
  #                              criteria.str7],
  #                  :select =>" customer_invoices.trans_bk,customer_invoices.trans_no,customer_invoices.trans_date, customer_invoices.inv_amt,customer_invoices.due_date,
  #                              customer_invoices.balance_amt,customer_invoices.sale_date,customer_invoices.term_code, customer_invoices.salesperson_code,customers.code as customer_code,
  #                              customers.name as customer_name,customers.contact1 as customer_contact1,customers.city,
  #                              customers.phone1,customers.fax1,customers.credit_limit,customer_categories.code as category_code,companies.name as company_name,companies.company_cd as company_code",
  #                  :order => "category_code ASC,customer_name ASC,trans_date ASC,trans_no ASC"
  #                        )    
  # end
  # 
  # #doing aging of invoices
  # def self.customer_invoices_aging(invoices,dt1)
  #   temp = []
  #   ll_serial_no = 0  
  #   invoices.each { |invoice|  
  #     li_due_days = 0
  #     ll_serial_no = ll_serial_no + 1
  #     ls_voucher_no = invoice.trans_bk + invoice.trans_no  
  #     ldec_t1_amt = 0 
  #     receipt_line = receipt_line(dt1,ls_voucher_no,invoice.trans_date)
  #     ldec_t1_amt= (receipt_line == nil or receipt_line.first.amt == nil) ? 0:receipt_line.first.amt.to_i
  #     ldec_balance_amt = invoice.inv_amt - ldec_t1_amt          
  #     li_due_days = dt1.to_date - invoice.trans_date.to_date          
  #     ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,ldec_current_amt = aging_group(li_due_days,ldec_balance_amt)    
  #     if(ldec_balance_amt != 0) 
  #       x = Customer::Customer_Aging_Table.new
  #       x.fill_temp_table(invoice,ll_serial_no,li_due_days,ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,  
  #         ldec_current_amt,ldec_balance_amt)
  #       temp << x                  
  #     end
  #   } 
  #   temp
  # end
  # 
  # #to calculate balance amt
  # def self.receipt_line(dt1,ls_voucher_no,ldt_inv_dt)
  #   Customer::CustomerReceiptLine.find_by_sql(["
  #                              select (sum(apply_amt) + sum(disctaken_amt)) as amt   
  #                              from customer_receipt_lines  
  #                              join companies on companies.id = customer_receipt_lines.company_id
  #                              where (trans_date <= ?) AND
  #                                    (voucher_no = ?) AND  
  #                                    (voucher_date = ?)",
  #                              dt1,ls_voucher_no,ldt_inv_dt]) 
  # end
  # 
  # #to calculate balance amt based on trans_bk
  # def self.receipt_line_using_trans_bk(dt1,ls_inv_bk,ls_inv_no,ldt_inv_dt)
  #   Customer::CustomerReceiptLine.find_by_sql(["
  #                              select sum(apply_amt) as amt
  #                              from customer_receipt_lines
  #                              join companies on companies.id = customer_receipt_lines.company_id
  #                              where (voucher_date <= ?) AND
  #                                    (trans_bk = ?) AND
  #                                    (trans_no = ?) AND 
  #                                    (trans_date = ?)",                                    
  #                                   dt1,ls_inv_bk,ls_inv_no,ldt_inv_dt])
  # end 
  # 
  # #to list receipts for aging
  # def self.customer_receipts(criteria)
  #   condition ="customer_receipts.company_id in(select company_id from user_companies where user_id=?) AND
  #                              (customer_categories.code between ? and ? and (0 = ? or customer_categories.code in (?))) AND 
  #                              (customers.code between ? and ? and (0 =? or customers.code in (?))) AND
  #                              (customers.salesperson_code between ? and ? and (0 =? or customers.salesperson_code in (?))) AND
  #                              (customer_receipts.account_period_code <= nvl(rtrim(ltrim(?)),customer_receipts.account_period_code)) AND
  #                              (customer_receipts.trans_date <= ?) AND 
  #                              (customer_receipts.trans_flag = 'A') "
  #   condition=convert_sql_to_db_specific(condition)
  #   Customer::CustomerReceipt.find(:all,
  #                  :joins =>" inner join customers  on customers.id = customer_receipts.customer_id 
  #                             inner join customer_categories on customer_categories.id = customers.customer_category_id 
  #                             inner join companies on companies.id = customer_receipts.company_id",
  #                  :conditions =>[condition,
  #                              criteria.user_id,
  #                              criteria.str1,   criteria.str2,  criteria.multiselect1.length, criteria.multiselect1,
  #                              criteria.str3,   criteria.str4,  criteria.multiselect2.length, criteria.multiselect2,
  #                              criteria.str5,   criteria.str6,  criteria.multiselect3.length, criteria.multiselect3,
  #                              criteria.str7,
  #                              criteria.dt1   ],
  #                  :select =>" customer_receipts.trans_bk,customer_receipts.trans_no,customer_receipts.trans_date,
  #                              customer_receipts.received_amt,customer_receipts.term_code, 
  #                              customer_receipts.balance_amt, customer_receipts.salesperson_code,customers.code as customer_code,
  #                              customers.name as customer_name,customers.contact1 as customer_contact1,customers.city,
  #                              customers.phone1,customers.fax1,customers.credit_limit,customer_categories.code as category_code,companies.name as company_name,companies.company_cd as company_code",
  #                  :order => "category_code ASC,customer_name ASC,trans_date ASC,trans_no ASC"
  #                        )
  # end
  # 
  # #doing aging of receipts
  # def self.customer_receipts_aging(receipts,dt1)
  #   temp = []
  #   ll_serial_no = 0   
  #   receipts.each{|receipt|
  #     if(receipt)            
  #       ldec_paid_amt = (receipt.received_amt != nil) ? receipt.received_amt : 0
  #       ldec_balance_amt = receipt.balance_amt
  #       ls_voucher_no = receipt.trans_bk + receipt.trans_no  
  #       ldec_t1_amt = 0
  #       ldec_t2_amt = 0
  #     else
  #       break
  #     end
  #     receipt_line = receipt_line_using_trans_bk(dt1,receipt.trans_bk,receipt.trans_no,receipt.trans_date)
  #     ldec_t1_amt= (receipt_line == nil or receipt_line.first.amt == nil) ? 0:receipt_line.first.amt.to_i
  #     receipt_line = receipt_line(dt1,ls_voucher_no,receipt.trans_date)
  #     ldec_t2_amt = (receipt_line == nil or receipt_line.first.amt == nil) ? 0: receipt_line.first.amt.to_i
  #     ldec_t1_amt = ldec_t1_amt + (ldec_t2_amt * -1)    
  #     ldec_balance_amt = ldec_paid_amt - ldec_t1_amt 
  #     ll_serial_no = ll_serial_no + 1     
  #     ldec_credit_amt = ldec_balance_amt   
  #     ldec_balance_amt = ldec_balance_amt * (-1)   
  #     li_due_days = dt1.to_date - receipt.trans_date.to_date      
  #     ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,ldec_current_amt = aging_group(li_due_days,ldec_balance_amt)
  #     if(ldec_balance_amt != 0)     
  #       x = Customer::Customer_Aging_Table.new 
  #       x.fill_temp_table_credit(receipt,ll_serial_no,ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,                                 
  #         ldec_group4_amt,ldec_credit_amt,ldec_current_amt,ldec_balance_amt)
  #       temp << x
  #     end
  #   }
  #   temp
  # end
  #
  # #Aging logic
  # def self.aging_group(li_due_days,ldec_balance_amt)
  #   li_group1 = 30
  #   li_group2 = 60
  #   li_group3 = 90
  #   ldec_group1_amt = 0   
  #   ldec_group2_amt = 0   
  #   ldec_group3_amt = 0   
  #   ldec_group4_amt = 0 
  #   ldec_current_amt = 0 
  #   if(li_due_days  <= 0)   
  #     ldec_current_amt = ldec_balance_amt   
  #   elsif(li_due_days >= 1 and (li_due_days <= li_group1))
  #     ldec_group1_amt = ldec_balance_amt    
  #   elsif(li_due_days >= (li_group1+1) and (li_due_days <= li_group2))
  #     ldec_group2_amt = ldec_balance_amt    
  #   elsif(li_due_days >= (li_group2+1) and (li_due_days <= li_group3))   
  #     ldec_group3_amt = ldec_balance_amt    
  #   else   
  #     ldec_group4_amt = ldec_balance_amt   
  #   end
  #   return ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,ldec_current_amt
  # end
  # 
  # 
  #  def self.customer_aging_detail(doc)   
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #    mstr_aging_table = []  
  #    #  if(criteria.str7 == '' or criteria.str7 == nil)
  #    #      criteria.str7 = criteria.str8
  #    #  end 
  #    ##  if(criteria.dt1.to_date.to_s == '1990-01-01')
  #    #  if(criteria.dt1.to_date.to_s == '01-01-1990')
  #    #     criteria.dt1 = criteria.dt2     
  #    #  end
  #    #  if(criteria.str7 != '' and criteria.str7 != 'zzzz')
  #    if( criteria.str8 != 'zzzz')
  #      ac_period_obj = Setup::AccountPeriod.find_by_sql(["select to_date as to_dt from account_periods where code = ? ",criteria.str8 ])
  #      criteria.dt2 = ac_period_obj.first.to_dt if ac_period_obj.first   
  #    end   
  #  
  #    invoices = customer_invoices(criteria)                      
  #    aging_invoices = customer_invoices_aging(invoices,criteria.dt2)
  #    aging_invoices.each { |i|
  #      mstr_aging_table << i  } 
  # 
  #    receipts = customer_receipts(criteria)                      
  #    aging_receipts =  customer_receipts_aging(receipts,criteria.dt2)
  #    aging_receipts.each { |i|
  #      mstr_aging_table << i  } 
  #       
  #    mstr_aging_table
  #  end

  def self.customer_aging_detail(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_customer_backdated_aging   #{criteria.user_id},    
                                                     '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
                                                     '#{criteria.dt4.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
                                                     '#{criteria.str1}', '#{criteria.str2}',    '#{criteria.multiselect1}',
                                                     '#{criteria.str3}', '#{criteria.str4}',    '#{criteria.multiselect2}',
                                                     '#{criteria.str5}', '#{criteria.str6}',    '#{criteria.multiselect3}',
                                                     '#{criteria.str9}', '#{criteria.str10}',   '#{criteria.multiselect4}',
                                                     '#{criteria.str8}',                                    
                                                     '#{criteria.str11}',
                                                     'D'")
    sql_query.commit_db_transaction 
    list
  end

  def self.customer_aging_summary(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_customer_backdated_aging   #{criteria.user_id},    
                                                     '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
                                                     '#{criteria.dt4.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
                                                     '#{criteria.str1}', '#{criteria.str2}',    '#{criteria.multiselect1}',
                                                     '#{criteria.str3}', '#{criteria.str4}',    '#{criteria.multiselect2}',
                                                     '#{criteria.str5}', '#{criteria.str6}',    '#{criteria.multiselect3}',
                                                     '#{criteria.str9}', '#{criteria.str10}',   '#{criteria.multiselect4}',
                                                     '#{criteria.str8}',                                    
                                                     '#{criteria.str11}',
                                                     'S'")
    sql_query.commit_db_transaction 
    list
  end
  #to list invoices for aging
  def self.customer_invoices(criteria)
    condition="customer_invoices.company_id in(select company_id from user_companies where user_id=?) AND
                              (customer_categories.code between ? and ? and (0 = ? or customer_categories.code in (?))) AND 
                              (customers.code between ? and ? and (0 = ? or customers.code in (?))) AND
                              (customers.salesperson_code between ? and ? and (0 = ? or customers.salesperson_code in (?))) AND
                              (customer_invoices.trans_date <= ?) AND       
                              (customer_invoices.account_period_code <= nvl(rtrim(ltrim(?)),customer_invoices.account_period_code)) AND
                              (customer_invoices.trans_flag = 'A') "
    condition = convert_sql_to_db_specific(condition)
    Customer::CustomerInvoice.find(:all,
      :joins =>" inner join customers  on customers.id = customer_invoices.customer_id 
                             inner join customer_categories on customer_categories.id = customers.customer_category_id 
                             inner join companies on companies.id = customer_invoices.company_id",
      :conditions =>[condition,
        criteria.user_id,
        criteria.str1,criteria.str2,  criteria.multiselect1.length, criteria.multiselect1,
        criteria.str3,criteria.str4,  criteria.multiselect2.length, criteria.multiselect2,
        criteria.str5,criteria.str6,  criteria.multiselect3.length, criteria.multiselect3,
        criteria.dt2,
        criteria.str8],
      :select =>" customer_invoices.trans_bk,customer_invoices.trans_no,customer_invoices.trans_date, customer_invoices.inv_amt,customer_invoices.due_date,
                              customer_invoices.balance_amt,customer_invoices.sale_date,customer_invoices.term_code, customer_invoices.salesperson_code,customers.code as customer_code,
                              customers.name as customer_name,customers.contact1 as customer_contact1,customers.city,
                              customers.phone1,customers.fax1,customers.credit_limit,customer_categories.code as category_code,companies.name as company_name,companies.company_cd as company_code",
      :order => "category_code ASC,customer_name ASC,trans_date ASC,trans_no ASC"
    )    
  end
 
  #doing aging of invoices
  def self.customer_invoices_aging(invoices,dt2)
    temp = []
    ll_serial_no = 0  
    invoices.each { |invoice|  
      li_due_days = 0
      ll_serial_no = ll_serial_no + 1
      ls_voucher_no = invoice.trans_bk + invoice.trans_no  
      ldec_t1_amt = 0 
      receipt_line = receipt_line(dt2,ls_voucher_no,invoice.trans_date)
      ldec_t1_amt= (receipt_line == nil or receipt_line.first.amt == nil) ? 0:receipt_line.first.amt.to_i
      ldec_balance_amt = invoice.inv_amt - ldec_t1_amt          
      li_due_days = dt2.to_date - invoice.trans_date.to_date          
      ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,ldec_current_amt = aging_group(li_due_days,ldec_balance_amt)    
      if(ldec_balance_amt != 0) 
        x = Customer::Customer_Aging_Table.new
        x.fill_temp_table(invoice,ll_serial_no,li_due_days,ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,  
          ldec_current_amt,ldec_balance_amt)
        temp << x                  
      end
    } 
    temp
  end
 
  #to calculate balance amt
  def self.receipt_line(dt2,ls_voucher_no,ldt_inv_dt)
    Customer::CustomerReceiptLine.find_by_sql(["
                              select (sum(apply_amt) + sum(disctaken_amt)) as amt   
                              from customer_receipt_lines  
                              join companies on companies.id = customer_receipt_lines.company_id
                              where (trans_date <= ?) AND
                                    (voucher_no = ?) AND  
                                    (voucher_date = ?)",
        dt2,ls_voucher_no,ldt_inv_dt]) 
  end
 
  #to calculate balance amt based on trans_bk
  def self.receipt_line_using_trans_bk(dt2,ls_inv_bk,ls_inv_no,ldt_inv_dt)
    Customer::CustomerReceiptLine.find_by_sql(["
                              select sum(apply_amt) as amt
                              from customer_receipt_lines
                              join companies on companies.id = customer_receipt_lines.company_id
                              where (voucher_date <= ?) AND
                                    (trans_bk = ?) AND
                                    (trans_no = ?) AND 
                                    (trans_date = ?)",                                    
        dt2,ls_inv_bk,ls_inv_no,ldt_inv_dt])
  end 
 
  #to list receipts for aging
  def self.customer_receipts(criteria)
    condition ="customer_receipts.company_id in(select company_id from user_companies where user_id=?) AND
                              (customer_categories.code between ? and ? and (0 = ? or customer_categories.code in (?))) AND 
                              (customers.code between ? and ? and (0 =? or customers.code in (?))) AND
                              (customers.salesperson_code between ? and ? and (0 =? or customers.salesperson_code in (?))) AND
                              (customer_receipts.account_period_code <= nvl(rtrim(ltrim(?)),customer_receipts.account_period_code)) AND
                              (customer_receipts.trans_date <= ?) AND 
                              (customer_receipts.trans_flag = 'A') "
    condition=convert_sql_to_db_specific(condition)
    Customer::CustomerReceipt.find(:all,
      :joins =>" inner join customers  on customers.id = customer_receipts.customer_id 
                             inner join customer_categories on customer_categories.id = customers.customer_category_id 
                             inner join companies on companies.id = customer_receipts.company_id",
      :conditions =>[condition,
        criteria.user_id,
        criteria.str1,   criteria.str2,  criteria.multiselect1.length, criteria.multiselect1,
        criteria.str3,   criteria.str4,  criteria.multiselect2.length, criteria.multiselect2,
        criteria.str5,   criteria.str6,  criteria.multiselect3.length, criteria.multiselect3,
        criteria.str8,
        criteria.dt2   ],
      :select =>" customer_receipts.trans_bk,customer_receipts.trans_no,customer_receipts.trans_date,
                              customer_receipts.received_amt,customer_receipts.term_code, 
                              customer_receipts.balance_amt, customer_receipts.salesperson_code,customers.code as customer_code,
                              customers.name as customer_name,customers.contact1 as customer_contact1,customers.city,
                              customers.phone1,customers.fax1,customers.credit_limit,customer_categories.code as category_code,companies.name as company_name,companies.company_cd as company_code",
      :order => "category_code ASC,customer_name ASC,trans_date ASC,trans_no ASC"
    )
  end
 
  #doing aging of receipts
  def self.customer_receipts_aging(receipts,dt2)
    temp = []
    ll_serial_no = 0   
    receipts.each{|receipt|
      if(receipt)            
        ldec_paid_amt = (receipt.received_amt != nil) ? receipt.received_amt : 0
        ldec_balance_amt = receipt.balance_amt
        ls_voucher_no = receipt.trans_bk + receipt.trans_no  
        ldec_t1_amt = 0
        ldec_t2_amt = 0
      else
        break
      end
      receipt_line = receipt_line_using_trans_bk(dt2,receipt.trans_bk,receipt.trans_no,receipt.trans_date)
      ldec_t1_amt= (receipt_line == nil or receipt_line.first.amt == nil) ? 0:receipt_line.first.amt.to_i
      receipt_line = receipt_line(dt2,ls_voucher_no,receipt.trans_date)
      ldec_t2_amt = (receipt_line == nil or receipt_line.first.amt == nil) ? 0: receipt_line.first.amt.to_i
      ldec_t1_amt = ldec_t1_amt + (ldec_t2_amt * -1)    
      ldec_balance_amt = ldec_paid_amt - ldec_t1_amt 
      ll_serial_no = ll_serial_no + 1     
      ldec_credit_amt = ldec_balance_amt   
      ldec_balance_amt = ldec_balance_amt * (-1)   
      li_due_days = dt2.to_date - receipt.trans_date.to_date      
      ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,ldec_current_amt = aging_group(li_due_days,ldec_balance_amt)
      if(ldec_balance_amt != 0)     
        x = Customer::Customer_Aging_Table.new 
        x.fill_temp_table_credit(receipt,ll_serial_no,ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,                                 
          ldec_group4_amt,ldec_credit_amt,ldec_current_amt,ldec_balance_amt)
        temp << x
      end
    }
    temp
  end

  #Aging logic
  def self.aging_group(li_due_days,ldec_balance_amt)
    li_group1 = 30
    li_group2 = 60
    li_group3 = 90
    ldec_group1_amt = 0   
    ldec_group2_amt = 0   
    ldec_group3_amt = 0   
    ldec_group4_amt = 0 
    ldec_current_amt = 0 
    if(li_due_days  <= 0)   
      ldec_current_amt = ldec_balance_amt   
    elsif(li_due_days >= 1 and (li_due_days <= li_group1))
      ldec_group1_amt = ldec_balance_amt    
    elsif(li_due_days >= (li_group1+1) and (li_due_days <= li_group2))
      ldec_group2_amt = ldec_balance_amt    
    elsif(li_due_days >= (li_group2+1) and (li_due_days <= li_group3))   
      ldec_group3_amt = ldec_balance_amt    
    else   
      ldec_group4_amt = ldec_balance_amt   
    end
    return ldec_group1_amt,ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,ldec_current_amt
  end
 
  #method for aging summary
  #  def self.customer_aging_summary(doc)
  #    mstr_temp_table = customer_aging_detail(doc)
  #    summary_sort(mstr_temp_table)
  #  end
 
  #grouping customer acc to code
  def self.summary_sort(mstr_temp_table) 
    final_table = []
    mstr_temp_table.each{ |x|
      if(final_table.empty?)
        final_table << mstr_temp_table.first
      else
        final_table.each{|y|        
          if(y.customer_code == x.customer_code)
            y.group1_amt = y.group1_amt + x.group1_amt
            y.group2_amt = y.group2_amt + x.group2_amt
            y.group3_amt = y.group3_amt + x.group3_amt
            y.group4_amt = y.group4_amt + x.group4_amt
            y.balance_amt = y.balance_amt + x.balance_amt
            y.credit_amt = y.credit_amt + x.credit_amt
            y.current_amt = y.current_amt + x.current_amt
            break
          elsif((final_table.index(y) + 1) == final_table.length and final_table.last.customer_code != x.customer_code)
            final_table << x
            break 
          end
        }
      end
    }
    final_table   
  end
 
  def self.statement_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_customer_statement_register
                                                          '#{criteria.str1}',      '#{criteria.str2}',      '#{criteria.multiselect1}',
                                                          '#{criteria.str3}',      '#{criteria.str4}',      '#{criteria.multiselect2}',
                                                          '#{criteria.str5}',      '#{criteria.str6}',      '#{criteria.multiselect3}',
                                                          '#{criteria.str7}',      '#{criteria.str8}',      '#{criteria.multiselect4}'")
    sql_query.commit_db_transaction
    list[0]['xmlcol']
  end

  def self.ledger_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_customer_ledger_register
                                                          '#{criteria.str1}',      '#{criteria.str2}',      '#{criteria.multiselect1}',
                                                          '#{criteria.str3}',      '#{criteria.str4}',      '#{criteria.multiselect2}',
                                                          '#{criteria.str5}',      '#{criteria.str6}',      '#{criteria.multiselect3}'")
    sql_query.commit_db_transaction
    list[0]['xmlcol']
  end

  def self.customer_invoice_format(invoice_id)  
    invoice = Customer::CustomerInvoice.active.find(:all,
      :joins=>"inner join customers  on customers.id = customer_invoices.customer_id
                                 inner join companies on companies.id = customer_invoices.company_id ",
      :conditions =>["customer_invoices.id = ?",invoice_id],
      :select => "trans_no,trans_date,inv_no,inv_date,customer_invoices.inv_type,due_date,customer_invoices.salesperson_code,term_code,
                                    sale_date,description,inv_amt,discount_amt,paid_amt,
                                    disctaken_amt,balance_amt,clear_amt,item_qty,customer_invoices.discount_per,
                                    companies.COMPANY_CD,companies.NAME as company_name,companies.ADDRESS1 as company_address1,companies.ADDRESS2 as company_address2,
                                    companies.CITY as company_city,
                                    companies.STATE as company_state,companies.ZIP as company_zip,companies.PHONE as company_phone,companies.FAX as company_fax,
                                    customers.CODE as customer_code,customers.NAME as customer_name,customers.ADDRESS1 as customer_address1,customers.ADDRESS2 as customer_address2,
                                    customers.CITY as customer_city,customers.STATE as customer_state,customers.ZIP as customer_zip,customers.COUNTRY as customer_country,
                                    customers.PHONE1 as customer_phone1,customers.PHONE2 as customer_phone2,
                                    customers.FAX1 as customer_fax,companies.company_logo_file as company_logo_file   ")
    invoices_lines = Customer::CustomerInvoiceLine.active.find(:all,
      :joins=>" left outer join gl_accounts on gl_accounts.id = customer_invoice_lines.gl_account_id
      ",
      :conditions =>["customer_invoice_lines.customer_invoice_id = ?",invoice_id],
      :select =>"customer_invoice_lines.TRANS_NO,customer_invoice_lines.TRANS_DATE,customer_invoice_lines.SERIAL_NO,
                                customer_invoice_lines.GL_AMT,customer_invoice_lines.DESCRIPTION,
                                gl_accounts.code as gl_account_code, gl_accounts.name as gl_account_name
      ")
    return invoice,invoices_lines
  end



  def self.customer_receipt_format(receipt_id)  
    receipt = Customer::CustomerReceipt.active.find(:all,
      :joins=>"inner join customers  on customers.id = customer_receipts.customer_id
                                 inner join companies on companies.id = customer_receipts.company_id 
                                 left outer join terms on terms.code = customer_receipts.term_code",
      :conditions =>["customer_receipts.id = ?",receipt_id],
      :select => "trans_no,trans_date,due_date,terms.name as term_name,description,balance_amt,applied_amt,received_amt,item_qty,check_date,check_no,customer_receipts.salesperson_code,receipt_type,
                                    companies.company_cd,companies.name as company_name,companies.address1 as company_address1,companies.address2 as company_address2,
                                    companies.city as company_city,companies.country as company_country,
                                    companies.state as company_state,companies.zip as company_zip,companies.phone as company_phone,companies.fax as company_fax,
                                    customers.code as customer_code,customers.name as customer_name,customers.address1 as customer_address1,customers.address2 as customer_address2,
                                    customers.city as customer_city,customers.state as customer_state,customers.zip as customer_zip,customers.country as customer_country,
                                    customers.phone1 as customer_phone1,customers.phone2 as customer_phone2,
                                    customers.fax1 as customer_fax,companies.company_logo_file as company_logo_file ")
    receipt_lines = Customer::CustomerReceiptLine.active.find(:all,
      :joins=>"left outer join gl_accounts on gl_accounts.id = customer_receipt_lines.gl_account_id ",
      :conditions =>["customer_receipt_lines.customer_receipt_id = ?",receipt_id],
      :select =>"voucher_no,voucher_date,original_amt,apply_amt,disctaken_amt,gl_accounts.code as gl_account_code                              
      ")
    return receipt,receipt_lines
  end



  def self.customer_credit_invoice_format(receipt_id)  
    receipt = Customer::CustomerReceipt.active.find(:all,
      :joins=>"inner join customers  on customers.id = customer_receipts.customer_id
                                 inner join companies on companies.id = customer_receipts.company_id 
                                 left outer join terms on terms.code = customer_receipts.term_code",
      :conditions =>["customer_receipts.id = ?",receipt_id],
      :select => "trans_no,trans_date,due_date,description,balance_amt,applied_amt,received_amt,item_qty,check_date,check_no,customer_receipts.salesperson_code,receipt_type,terms.name as term_name,
                                    companies.company_cd,companies.name as company_name,companies.address1 as company_address1,companies.address2 as company_address2,
                                    companies.city as company_city,companies.country as company_country,
                                    companies.state as company_state,companies.zip as company_zip,companies.phone as company_phone,companies.fax as company_fax,
                                    customers.code as customer_code,customers.name as customer_name,customers.address1 as customer_address1,customers.address2 as customer_address2,
                                    customers.city as customer_city,customers.state as customer_state,customers.zip as customer_zip,customers.country as customer_country,
                                    customers.phone1 as customer_phone1,customers.phone2 as customer_phone2,
                                    customers.fax1 as customer_fax,companies.company_logo_file as company_logo_file ")
    receipt_lines = Customer::CustomerReceiptLine.active.find(:all,
      :joins=>"left outer join gl_accounts on gl_accounts.id = customer_receipt_lines.gl_account_id",
      :conditions =>["customer_receipt_lines.customer_receipt_id = ?",receipt_id],
      :select =>"voucher_no,voucher_date,original_amt,apply_amt,disctaken_amt,gl_accounts.code as gl_account_code                              
      ")
    return receipt,receipt_lines
  end


  ## Prototype services for customer info screen
  def self.customer_info_detail(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    user_id = parse_xml(doc/:criteria/'user_id')
    current_time = Time.new.strftime("%Y-%m-%d 00:00:00")
    account_period_code = Setup::AccountPeriod.period_from_date(Time.now).code
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction()
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_customer_backdated_aging  
    '#{user_id}',
    '#{current_time}',  '#{current_time}',
    '#{criteria.str3}', '#{criteria.str4}',    '#{criteria.multiselect2}',
    '#{criteria.str1}', '#{criteria.str2}',    '#{criteria.multiselect1}',
    '',                 'zzzz',                 '',
    '',                 'zzzz',                 '' ,
    '#{account_period_code}','I','S'")
    sql_query.commit_db_transaction 
    return list    
  end

  private_class_method :customer_invoices, :customer_invoices_aging, :customer_receipts,:customer_receipts_aging,:receipt_line, :receipt_line_using_trans_bk, :aging_group

end
