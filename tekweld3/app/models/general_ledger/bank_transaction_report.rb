class GeneralLedger::BankTransactionReport < Crud
  include General
  require'linguistics'
  #  def self.deposit_register(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
  #    sql_query = ActiveRecord::Base.connection();
  #    #    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
  #    sql_query.begin_db_transaction 
  #    sql = "
  #      (select vendors.name as name ,bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code, post_flag,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,vendors.code as account_code,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,banks.code as bank_code,banks.name as bank_name,
  #             companies.name as company_name,companies.company_cd as company_code from bank_transactions
  #                         inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #                    inner join companies on companies.id = bank_transactions.company_id 
  #                         inner join banks on gl_accounts.bank_id = banks.id
  # left outer join types on (
  #		             types.type_cd = 'bank_payment'
  #		             and types.subtype_cd = 'account_type'
  #		             and bank_transactions.account_flag = types.value 
  #	)
  #
  #join vendors on vendors.id = bank_transactions.account_id and account_flag = 'V' and trans_type = 'DEPS' where
  #credit_amt<>0 AND
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?)))  AND
  #                        (vendors.code between ? and ? AND (0 = ? or vendors.code in (?)))  AND
  #                        (banks.code between ? and ? AND (0=? or banks.code in (?)))   AND
  #                        (nvl(bank_transactions.deposit_no,'') between ? and ? AND (0 =? or bank_transactions.deposit_no in (?))) AND
  #                        (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  #                        (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #                        (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?   
  #
  #          )
  #union all
  #(select customers.name as name,bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code,
  #	            post_flag,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,customers.code as account_code,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,banks.code as bank_code,banks.name as bank_name,
  #companies.name as company_name,companies.company_cd as company_code from bank_transactions
  # inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #inner join companies on companies.id = bank_transactions.company_id 
  #                         inner join banks on gl_accounts.bank_id = banks.id
  #left outer join types on (
  #		             types.type_cd = 'bank_payment'
  #		             and types.subtype_cd = 'account_type'
  #		             and bank_transactions.account_flag = types.value
  #	)
  #
  #join customers on customers.id = bank_transactions.account_id and account_flag = 'C' and  trans_type = 'DEPS' where
  #credit_amt<>0 AND
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                        (customers.code between ? and ? AND (0 = ? or customers.code in (?)))  AND
  #           (banks.code between ? and ? AND (0=? or banks.code in (?))) AND
  #    (nvl(bank_transactions.deposit_no,'') between ? and ? AND (0 =? or bank_transactions.deposit_no in (?)))  AND
  # (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?))) AND
  #   (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #    (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ? 
  # )
  #union all
  #(select banks.name as name , bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code,
  #	            post_flag,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,f.code as account_code,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,banks.code as bank_code,banks.name as bank_name,
  # companies.name as company_name,companies.company_cd as company_code from bank_transactions
  # inner join gl_accounts e  on e.id = bank_transactions.account_id
  #                         inner join banks f on e.bank_id = f.id
  #inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #inner join companies on companies.id = bank_transactions.company_id 
  #left outer join types on (
  #		             types.type_cd = 'bank'
  #		             and bank_transactions.account_flag = types.value 
  #	)
  # 
  #inner join banks on gl_accounts.bank_id = banks.id and account_flag = 'B' and trans_type = 'DEPS' where
  #credit_amt<>0 AND
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                        (banks.code between ? and ? AND (0 = ? or banks.code in (?))) AND
  #         (f.code between ? and ? AND (0=? or f.code in (?)))  AND
  #  (nvl(bank_transactions.deposit_no,'') between ? and ? AND (0 =? or bank_transactions.deposit_no in (?)))  AND
  #(nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?))) AND
  # (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #   (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?  
  #)
  #union all
  #(select gl_accounts.name as name,bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code,
  #	            post_flag,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,gl_accounts.code as account_code,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no ,banks.code as bank_code ,banks.name as bank_name,
  #companies.name as company_name,companies.company_cd as company_code from bank_transactions
  # inner join gl_accounts e on e.id = bank_transactions.bank_id
  #                         inner join banks on e.bank_id = banks.id
  #inner join companies on companies.id = bank_transactions.company_id 
  #left outer join types on (
  #		             types.type_cd = 'bank_payment'
  #		             and types.subtype_cd = 'account_type'
  #		             and bank_transactions.account_flag = types.value 
  #	)
  #
  #join gl_accounts on gl_accounts.id = bank_transactions.account_id and account_flag = 'G' and  trans_type = 'DEPS' where
  #credit_amt<>0 AND
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?)))  AND
  #                        (gl_accounts.code between ? and ? AND (0 = ? or gl_accounts.code in (?))) AND
  #                    (banks.code between ? and ? AND (0=? or banks.code in (?)))  AND
  #                     (nvl(bank_transactions.deposit_no,'') between ? and ? AND (0 =? or bank_transactions.deposit_no in (?)))  AND
  #                  (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  # (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #   (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?   
  # )
  #
  #
  #    "
  #    sql = convert_sql_to_db_specific(sql)
  #    list= GeneralLedger::BankTransaction.active.find_by_sql [sql,criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length, criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length, criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length, criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length, criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length, criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length, criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length, criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length, criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length, criteria.multiselect9,
  #      criteria.str19,     criteria.str20,     criteria.multiselect10.length,criteria.multiselect10,
  #      criteria.dt3,       criteria.dt4,
  #      criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length,criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length,criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length,criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length,criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length,criteria.multiselect9,
  #      criteria.str19,     criteria.str20,     criteria.multiselect10.length,criteria.multiselect10,
  #      criteria.dt3,       criteria.dt4,
  #      criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length,criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length,criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length,criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length,criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length,criteria.multiselect9,
  #      criteria.str19,     criteria.str20,     criteria.multiselect10.length,criteria.multiselect10,
  #      criteria.dt3,       criteria.dt4,
  #      criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length,criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length,criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length,criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length,criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length,criteria.multiselect9,
  #      criteria.str19,     criteria.str20,     criteria.multiselect10.length,criteria.multiselect10,
  #      criteria.dt3,      criteria.dt4
  #    ]
  #    sql_query.commit_db_transaction 
  #    list
  #  end 
  
  def self.deposit_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_bank_deposit_register  '#{criteria.user_id}',
      '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
      '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
      '#{criteria.str1[0,8]}', '#{criteria.str2[0,8]}',  '#{criteria.multiselect1}',
      '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect2}',                                     
      '#{criteria.str5[0,1]}', '#{criteria.str6[0,1]}',  '#{criteria.multiselect3}',
      '#{criteria.str7[0,4]}', '#{criteria.str8[0,4]}',  '#{criteria.multiselect4}',
      '#{criteria.str9}',      '#{criteria.str10}',      '#{criteria.multiselect5}',
      '#{criteria.str11}',     '#{criteria.str12}',      '#{criteria.multiselect6}',
      '#{criteria.str13}',     '#{criteria.str14}',      '#{criteria.multiselect7}',
      '#{criteria.str15}',     '#{criteria.str16}',      '#{criteria.multiselect8}',
      '#{criteria.str17}',     '#{criteria.str18}',      '#{criteria.multiselect9}',
      '#{criteria.str19}',     '#{criteria.str20}',      '#{criteria.multiselect10}'")
    sql_query.commit_db_transaction 
    list
  end
  
  #  def self.payment_register(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #    sql_query = ActiveRecord::Base.connection();
  #    #    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
  #    sql_query.begin_db_transaction
  #    sql = "
  #      (select vendors.name as name ,bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code	,
  #	            post_flag,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,vendors.code as account_code,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,banks.name as bank_name,banks.code as bank_code,
  #      companies.name as company_name,companies.company_cd as company_code  from bank_transactions
  #left outer join types on (
  #		             types.type_cd = 'bank_payment'
  #		             and types.subtype_cd = 'account_type'
  #		             and bank_transactions.account_flag = types.value 
  #	)
  #                          inner join companies on companies.id = bank_transactions.company_id 
  #                         inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #                         inner join banks on gl_accounts.bank_id = banks.id
  #                         join vendors on vendors.id = bank_transactions.account_id and 
  #                         account_flag = 'V' and trans_type = 'PAYM' where debit_amt<>0 AND
  #                       (bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                        (vendors.code between ? and ? AND (0 = ? or vendors.code in (?))) AND
  #                        (banks.code between ? and ? AND (0=? or banks.code in (?)))   AND
  #                        (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  #                        (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #                        (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?   
  # )
  #union all
  #(select customers.name as name,bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code	,
  #	            post_flag,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,customers.code as account_code,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,banks.name as bank_name,banks.code as bank_code,
  # companies.name as company_name,companies.company_cd as company_code  from bank_transactions
  #left outer join types on (
  #		             types.type_cd = 'bank_payment'
  #		             and types.subtype_cd = 'account_type'
  #		             and bank_transactions.account_flag = types.value 
  #	)
  #                         inner join companies on companies.id = bank_transactions.company_id 
  #                         inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #                         inner join banks on gl_accounts.bank_id = banks.id
  #join customers on customers.id = bank_transactions.account_id and account_flag = 'C' and  trans_type = 'PAYM' where
  #debit_amt<>0 AND
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                        (customers.code between ? and ? AND (0 = ? or customers.code in (?))) AND
  #                        (banks.code between ? and ? AND (0=? or banks.code in (?)))   AND
  #                        (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  #                        (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #                        (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?  
  #)
  #union all
  #(select banks.name as name , bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code	,
  #	            post_flag,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,f.code as account_code,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,banks.name as bank_name,banks.code as bank_code,
  # companies.name as company_name,companies.company_cd as company_code  from bank_transactions
  #left outer join types on (
  #		             types.type_cd = 'bank'
  #		             and bank_transactions.account_flag = types.value 
  #	)
  # inner join companies on companies.id = bank_transactions.company_id 
  #inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #inner join banks on gl_accounts.bank_id = banks.id 
  #inner join gl_accounts e on e.id = bank_transactions.account_id
  #inner join banks f on e.bank_id = f.id and account_flag = 'B' and trans_type = 'PAYM' where
  #debit_amt<>0 AND
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                        (banks.code between ? and ? AND (0 = ? or banks.code in (?))) AND
  #                       (banks.code between ? and ? AND (0=? or banks.code in (?)))   AND
  #                        (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  #                        (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #                        (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?  
  #)
  #union all
  #(select gl_accounts.name as name,bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code	,
  #	            post_flag,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,g.code as account_code,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,banks.name as bank_name,banks.code as bank_code,
  # companies.name as company_name,companies.company_cd as company_code  from bank_transactions
  #left outer join types on (
  #		             types.type_cd = 'bank_payment'
  #		             and types.subtype_cd = 'account_type'
  #		             and bank_transactions.account_flag = types.value 
  #	)
  #join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #join gl_accounts g on g.id = bank_transactions.account_id
  # inner join companies on companies.id = bank_transactions.company_id 
  #inner join banks on gl_accounts.bank_id = banks.id  and account_flag = 'G' and  trans_type = 'PAYM' where
  #debit_amt<>0 AND
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                        (gl_accounts.code between ? and ? AND (0 = ? or gl_accounts.code in (?))) AND
  #                        (banks.code between ? and ? AND (0=? or banks.code in (?)))   AND
  #                        (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  #                        (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #                        (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?  
  #)
  #
  #
  #    "
  #  
  #    sql = convert_sql_to_db_specific(sql)
  #    list=GeneralLedger::BankTransaction.active.find_by_sql [sql,criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length,criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length,criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length,criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length,criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length,criteria.multiselect9,
  #      criteria.dt3,       criteria.dt4,
  #      criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length,criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length,criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length,criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length,criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length,criteria.multiselect9,
  #      criteria.dt3,       criteria.dt4,
  #      criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length,criteria.multiselect5, 
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length,criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length,criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length,criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length,criteria.multiselect9,
  #      criteria.dt3,       criteria.dt4,
  #      criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length,criteria.multiselect5 ,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length,criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length,criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length,criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length,criteria.multiselect9,
  #      criteria.dt3,       criteria.dt4
  #    ]
  #    sql_query.commit_db_transaction 
  #    list
  ##    list=GeneralLedger::BankTransaction.active.find_by_sql ["SELECT trans_date, 
  ##	account_period_code,
  ##	trans_no, 
  ##	account_id, 
  ##	payment_type, 
  ##	check_no, 
  ##	check_date, 
  ##	debit_amt,
  ##	( CASE WHEN account_flag = 'C' THEN (SELECT name FROM customers WHERE id = a.account_id)
  ##				WHEN account_flag = 'V' THEN (SELECT name FROM vendors WHERE id = a.account_id)
  ##				WHEN account_flag = 'B' THEN (SELECT name FROM banks WHERE account_id = a.account_id)
  ##				WHEN account_flag = 'G' THEN (SELECT name FROM gl_accounts WHERE id = a.account_id)
  ##	 END
  ##	) as account_name,
  ##	account_flag,
  ##	trans_bk
  ##FROM bank_transactions a
  ##
  ##WHERE debit_amt <> 0" ]
  #  end 

  def self.payment_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_bank_payment_register  '#{criteria.user_id}',
      '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
      '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
      '#{criteria.str1[0,8]}', '#{criteria.str2[0,8]}',  '#{criteria.multiselect1}',
      '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect2}',                                     
      '#{criteria.str5[0,1]}', '#{criteria.str6[0,1]}',  '#{criteria.multiselect3}',
      '#{criteria.str7[0,4]}', '#{criteria.str8[0,4]}',  '#{criteria.multiselect4}',
      '#{criteria.str9}',      '#{criteria.str10}',      '#{criteria.multiselect5}',
      '#{criteria.str11}',     '#{criteria.str12}',      '#{criteria.multiselect6}',
      '#{criteria.str13}',     '#{criteria.str14}',      '#{criteria.multiselect7}',
      '#{criteria.str15}',     '#{criteria.str16}',      '#{criteria.multiselect8}',
      '#{criteria.str17}',     '#{criteria.str18}',      '#{criteria.multiselect9}'")
    sql_query.commit_db_transaction 
    list
  end
  
  #  def self.transfer_register(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #    sql_query = ActiveRecord::Base.connection();
  #    sql_query.begin_db_transaction
  #    sql ="
  # (select banks.name as name , bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code	,
  #	            post_flag,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,ACCOUNT_ID,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,banks.code as bank_code,banks.name as bank_name,
  #companies.name as company_name,companies.company_cd as company_code,d.code as account_code from bank_transactions
  #left outer join types on (
  #		             types.type_cd = 'bank'
  #		             and bank_transactions.account_flag = types.value 
  #	)
  #inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #inner join banks on gl_accounts.bank_id = banks.id 
  #inner join gl_accounts c on c.id= bank_transactions.account_id
  #inner join banks d on bank_transactions.account_id = d.id  and account_flag = 'B' 
  # inner join companies on companies.id = bank_transactions.company_id and trans_type = 'TRFR' where
  #bank_transactions.debit_amt<>0 AND
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                        (banks.code between ? and ? AND (0 = ? or banks.code in (?))) AND
  #                        (d.code between ? and ? AND (0 = ? or d.code in (?))) AND
  #                       (nvl(bank_transactions.deposit_no,'') between ? and ? AND (0 =? or bank_transactions.deposit_no in (?)))  AND
  #                  (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  #             (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #                 (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?   
  #     
  # )
  #
  #
  #
  #    "
  #    sql = convert_sql_to_db_specific(sql)
  #    list = GeneralLedger::BankTransaction.active.find_by_sql [sql,criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,4], criteria.str6[0,4], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7,      criteria.str8,      criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9 ,     criteria.str10,     criteria.multiselect5.length,criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length,criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length,criteria.multiselect7,
  #      criteria.str15[0,4],criteria.str16[0,4],criteria.multiselect8.length,criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length,criteria.multiselect9,
  #      criteria.dt3,       criteria.dt4
  #    ]
  #    sql_query.commit_db_transaction 
  #    list
  #  end 
  
  def self.transfer_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_bank_transfer_register  #{criteria.user_id},
      '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
      '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
      '#{criteria.str1[0,8]}', '#{criteria.str2[0,8]}',  '#{criteria.multiselect1}',
      '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect2}',                                     
      '#{criteria.str5[0,1]}', '#{criteria.str6[0,1]}',  '#{criteria.multiselect3}',
      '#{criteria.str7[0,4]}', '#{criteria.str8[0,4]}',  '#{criteria.multiselect4}',
      '#{criteria.str9}',      '#{criteria.str10}',      '#{criteria.multiselect5}',
      '#{criteria.str11}',     '#{criteria.str12}',      '#{criteria.multiselect6}',
      '#{criteria.str13}',     '#{criteria.str14}',      '#{criteria.multiselect7}',
      '#{criteria.str15}',     '#{criteria.str16}',      '#{criteria.multiselect8}',
      '#{criteria.str17}',     '#{criteria.str18}',      '#{criteria.multiselect9}'")
    sql_query.commit_db_transaction 
    list
  end
  #inner join banks d on gl_accounts.bank_id = d.id  and account_flag = 'B' 
  #  def self.transaction_register(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #    sql_query = ActiveRecord::Base.connection();
  #    sql_query.begin_db_transaction
  #    sql = "
  #      (select vendors.name as name ,bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code	,
  #	            post_flag,CLEAR_FLAG,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,ACCOUNT_ID,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,companies.name as company_name,companies.company_cd as company_code,banks.code as bank_code,banks.name as bank_name,
  #                    vendors.code as account_code,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag
  # from bank_transactions
  #inner join vendors on vendors.id = bank_transactions.account_id
  #inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #inner join banks on gl_accounts.bank_id = banks.id
  #left outer join types on (
  #		             types.type_cd = 'bank_payment'
  #		             and types.subtype_cd = 'account_type'
  #		             and bank_transactions.account_flag = types.value 
  #	) 
  #inner join companies on companies.id = bank_transactions.company_id and account_flag = 'V'  where
  #((bank_transactions.trans_type='TRFR' AND DEBIT_AMT<>0) OR
  #             (bank_transactions.trans_type='PAYM' AND DEBIT_AMT<>0) OR
  #             (bank_transactions.trans_type='DEPS' AND CREDIT_AMT<>0))  and
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                        (vendors.code between ? and ? AND (0 = ? or vendors.code in (?)))  AND
  #                        (banks.code between ? and ? AND (0=? or banks.code in (?)))   AND
  #                        (nvl(bank_transactions.deposit_no,'') between ? and ? AND (0 =? or bank_transactions.deposit_no in (?))) AND
  #                        (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  #                        (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #                        (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?
  #                         )
  #union all
  #(select customers.name as name,bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code	,
  #	            post_flag,CLEAR_FLAG,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,ACCOUNT_ID,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,companies.name as company_name,companies.company_cd as company_code,banks.code as bank_code,banks.name as bank_name,
  #                    customers.code as account_code,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag
  #from bank_transactions
  #inner join customers on customers.id = bank_transactions.account_id 
  #inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #inner join banks on gl_accounts.bank_id = banks.id
  #left outer join types on (
  #		             types.type_cd = 'bank_payment'
  #		             and types.subtype_cd = 'account_type'
  #		             and bank_transactions.account_flag = types.value
  #	)
  #inner join companies on companies.id = bank_transactions.company_id and account_flag = 'C'  where
  #((bank_transactions.trans_type='TRFR' AND DEBIT_AMT<>0) OR
  #             (bank_transactions.trans_type='PAYM' AND DEBIT_AMT<>0) OR
  #             (bank_transactions.trans_type='DEPS' AND CREDIT_AMT<>0))  and
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                         (customers.code between ? and ? AND (0 = ? or customers.code in (?)))  AND
  #                        (banks.code between ? and ? AND (0=? or banks.code in (?)))   AND
  #                        (nvl(bank_transactions.deposit_no,'') between ? and ? AND (0 =? or bank_transactions.deposit_no in (?))) AND
  #                        (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  #                        (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #                        (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?
  #)
  #union all
  #(select banks.name as name , bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code	,
  #	            post_flag,CLEAR_FLAG,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,ACCOUNT_ID,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,companies.name as company_name,companies.company_cd as company_code,banks.code as bank_code,banks.name as bank_name,
  #                    c.code as account_code,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag
  #from bank_transactions
  #inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
  #inner join banks on gl_accounts.bank_id = banks.id
  #inner join gl_accounts c on c.id = bank_transactions.account_id
  #inner join banks d on c.bank_id = d.id
  #left outer join types on (
  #		             types.type_cd = 'bank'
  #		             and bank_transactions.account_flag = types.value 
  #	)
  #inner join companies on companies.id = bank_transactions.company_id and account_flag = 'B'  where
  #((bank_transactions.trans_type='TRFR' AND DEBIT_AMT<>0) OR
  #             (bank_transactions.trans_type='PAYM' AND DEBIT_AMT<>0) OR
  #             (bank_transactions.trans_type='DEPS' AND CREDIT_AMT<>0) ) and
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                       (banks.code between ? and ? AND (0 = ? or banks.code in (?)))  AND
  #                        (banks.code between ? and ? AND (0=? or banks.code in (?)))   AND
  #                        (nvl(bank_transactions.deposit_no,'') between ? and ? AND (0 =? or bank_transactions.deposit_no in (?))) AND
  #                        (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  #                        (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #                        (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?
  #)
  #union all
  #(select gl_accounts.name as name,bank_transactions.TRANS_FLAG,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code	,
  #	            post_flag,CLEAR_FLAG,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,ACCOUNT_ID,deposit_no,	
  #	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
  #	            serial_no,companies.name as company_name,companies.company_cd as company_code,banks.code as bank_code,banks.name as bank_name,
  #                    gl_accounts.code as account_code,(Case When bank_transactions.clear_flag in ('N')  
  #                       Then ('Not clear')
  #                      Else ('Cleared') 
  #                              End) as clear_flag
  #from bank_transactions
  #inner join  gl_accounts c on c.id = bank_transactions.bank_id
  #inner join banks on c.bank_id = banks.id
  #inner join gl_accounts on gl_accounts.id = bank_transactions.account_id
  #left outer join types on (
  #		             types.type_cd = 'bank_payment'
  #		             and types.subtype_cd = 'account_type'
  #		             and bank_transactions.account_flag = types.value 
  #	)
  #inner join companies on companies.id = bank_transactions.company_id and account_flag = 'G' where
  #((bank_transactions.trans_type='TRFR' AND DEBIT_AMT<>0) OR
  #             (bank_transactions.trans_type='PAYM' AND DEBIT_AMT<>0) OR
  #             (bank_transactions.trans_type='DEPS' AND CREDIT_AMT<>0))  and
  #(bank_transactions.company_id in (select company_id from user_companies where user_id=?)) AND  
  #                        (bank_transactions.account_period_code between ? and ? AND (0 =? or bank_transactions.account_period_code in (?))) AND  
  #                        nvl(bank_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND                          
  #                        (bank_transactions.trans_no between ? and ? AND (0 =? or bank_transactions.trans_no in (?))) AND 
  #                        (bank_transactions.account_flag between ? and ? AND (0 =? or account_flag in (?))) AND
  #                        (bank_transactions.payment_type between ? and ? AND (0 = ? or bank_transactions.payment_type in (?))) AND
  #                       (c.code between ? and ? AND (0 = ? or gl_accounts.code in (?)))  AND
  #                        (banks.code between ? and ? AND (0=? or banks.code in (?)))   AND
  #                        (nvl(bank_transactions.deposit_no,'') between ? and ? AND (0 =? or bank_transactions.deposit_no in (?))) AND
  #                        (nvl(bank_transactions.ref_no,'') between ? and ? AND (0 =? or bank_transactions.ref_no in (?)))  AND
  #                        (bank_transactions.trans_bk between ? and ? AND (0 =? or bank_transactions.trans_bk in (?))) AND
  #                        (bank_transactions.check_no between ? and ? AND (0 =? or bank_transactions.check_no in (?))) AND
  #                        nvl(bank_transactions.check_date,'1990-01-01 00:00:00') between ? and ?
  #)  
  #
  #
  #    "
  #    sql = convert_sql_to_db_specific(sql)
  #    list= GeneralLedger::BankTransaction.active.find_by_sql [sql,criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length, criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length, criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length, criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length, criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length, criteria.multiselect9,
  #      criteria.str19,     criteria.str20,     criteria.multiselect10.length,criteria.multiselect10,
  #      criteria.dt3,       criteria.dt4,
  #      criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length, criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length, criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length, criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length, criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length, criteria.multiselect9,
  #      criteria.str19,     criteria.str20,     criteria.multiselect10.length,criteria.multiselect10,
  #      criteria.dt3,       criteria.dt4,
  #      criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length, criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length, criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length, criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length, criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length, criteria.multiselect9,
  #      criteria.str19,     criteria.str20,     criteria.multiselect10.length,criteria.multiselect10,
  #      criteria.dt3,       criteria.dt4,
  #      criteria.user_id,
  #      criteria.str1[0,8], criteria.str2[0,8], criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,       criteria.dt2,
  #      criteria.str3,      criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,                                     
  #      criteria.str5[0,1], criteria.str6[0,1], criteria.multiselect3.length,criteria.multiselect3,
  #      criteria.str7[0,4], criteria.str8[0,4], criteria.multiselect4.length,criteria.multiselect4,
  #      criteria.str9,      criteria.str10,     criteria.multiselect5.length, criteria.multiselect5,
  #      criteria.str11,     criteria.str12,     criteria.multiselect6.length, criteria.multiselect6,
  #      criteria.str13,     criteria.str14,     criteria.multiselect7.length, criteria.multiselect7,
  #      criteria.str15,     criteria.str16,     criteria.multiselect8.length, criteria.multiselect8,
  #      criteria.str17,     criteria.str18,     criteria.multiselect9.length, criteria.multiselect9,
  #      criteria.str19,     criteria.str20,     criteria.multiselect10.length,criteria.multiselect10,
  #      criteria.dt3,       criteria.dt4
  #    ]
  #    sql_query.commit_db_transaction 
  #    list
  #  end 
  
  
  def self.transaction_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_bank_transaction_register  #{criteria.user_id},
      '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
      '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
      '#{criteria.str1[0,8]}', '#{criteria.str2[0,8]}',  '#{criteria.multiselect1}',
      '#{criteria.str3}',      '#{criteria.str4}',       '#{criteria.multiselect2}',                                     
      '#{criteria.str5[0,1]}', '#{criteria.str6[0,1]}',  '#{criteria.multiselect3}',
      '#{criteria.str7[0,4]}', '#{criteria.str8[0,4]}',  '#{criteria.multiselect4}',
      '#{criteria.str9}',      '#{criteria.str10}',      '#{criteria.multiselect5}',
      '#{criteria.str11}',     '#{criteria.str12}',      '#{criteria.multiselect6}',
      '#{criteria.str13}',     '#{criteria.str14}',      '#{criteria.multiselect7}',
      '#{criteria.str15}',     '#{criteria.str16}',      '#{criteria.multiselect8}',
      '#{criteria.str17}',     '#{criteria.str18}',      '#{criteria.multiselect9}',
      '#{criteria.str19}',     '#{criteria.str20}',      '#{criteria.multiselect10}'")
    sql_query.commit_db_transaction 
    list
  end
  
  #  def self.journal_register(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #    condition = "  ( gl_transactions.company_id in (select company_id from user_companies where user_id=?))
  #                         AND gl_transactions.trans_flag='A' AND
  #                         (gl_transactions.account_period_code between ? and ? AND (0 =? or gl_transactions.account_period_code in (?)))  AND
  #                         nvl(gl_transactions.trans_date,'1990-01-01 00:00:00') between ? and ? AND 
  #                        (gl_transactions.trans_no between ? and ? AND (0 =? or gl_transactions.trans_no in (?))) AND                       
  #                         (gl_transactions.trans_bk between ? and ? AND  (0 =? or gl_transactions.trans_bk in (?)))
  #    "
  #    condition = convert_sql_to_db_specific(condition)
  #    sql_query = ActiveRecord::Base.connection();
  #    sql_query.begin_db_transaction
  #    list = GeneralLedger::GlTransaction.active.find(:all,
  #      :joins =>  'join gl_transaction_lines b on b.gl_transaction_id=gl_transactions.id
  #                   join gl_accounts c on c.id=b.gl_account_id
  #                  inner join companies on companies.id = gl_transactions.company_id',
  #      :conditions => [condition,criteria.user_id,criteria.str1[0,8],criteria.str2[0,8],criteria.multiselect1.length,criteria.multiselect1,
  #        criteria.dt1,criteria.dt2,
  #        criteria.str3, criteria.str4, criteria.multiselect2.length,criteria.multiselect2,                                          
  #        criteria.str5, criteria.str6, criteria.multiselect3.length,criteria.multiselect3] ,
  #      :select => 'gl_transactions.trans_bk,gl_transactions.trans_no,gl_transactions.trans_date,gl_transactions.account_period_code,gl_transactions.trans_type,gl_transactions.post_flag,b.debit_amt,b.credit_amt,b.ref_no,b.ref_date,b.description,b.serial_no,c.name as bank_name,companies.name as company_name,companies.company_cd as company_code'                       
  #    )   
  #    sql_query.commit_db_transaction 
  #    list
  #  end
   
  
  #  def self.journal_register(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #    condition = "  ( gl_details.company_id in (select company_id from user_companies where user_id=?))
  #                         AND gl_details.trans_flag='A' AND
  #                         (gl_details.account_period_code between ? and ? AND (0 =? or gl_details.account_period_code in (?)))  AND
  #                         nvl(gl_details.trans_date,'1990-01-01 00:00:00') between ? and ? AND 
  #                        (gl_details.trans_no between ? and ? AND (0 =? or gl_details.trans_no in (?))) AND                       
  #                         (gl_details.trans_bk between ? and ? AND  (0 =? or gl_details.trans_bk in (?)))
  #    "
  #    condition = convert_sql_to_db_specific(condition)
  #    sql_query = ActiveRecord::Base.connection();
  #    sql_query.begin_db_transaction
  ##    list = GeneralLedger::GlDetail.active.find(:all,
  ##      :joins =>  'join gl_accounts c on c.id=gl_details.gl_account_id
  ##                  inner join companies on companies.id = gl_details.company_id',
  ##      :conditions => [condition,criteria.user_id,criteria.str1[0,8],criteria.str2[0,8],criteria.multiselect1.length,criteria.multiselect1,
  ##        criteria.dt1,criteria.dt2,
  ##        criteria.str3, criteria.str4, criteria.multiselect2.length,criteria.multiselect2,                                          
  ##        criteria.str5, criteria.str6, criteria.multiselect3.length,criteria.multiselect3] ,
  ##      :select => 'gl_details.trans_bk,gl_details.trans_no,gl_details.trans_date,gl_details.account_period_code,gl_details.trans_type,gl_details.post_flag,gl_details.debit_amt,gl_details.credit_amt,gl_details.ref_no,gl_details.ref_date,gl_details.description,c.name as bank_name,companies.name as company_name,companies.company_cd as company_code'                       
  ##    )   
  #    list=GeneralLedger::GlDetail.find_by_sql(["select cast((select(SELECT gl_details.trans_bk,gl_details.trans_no,gl_details.trans_date,gl_details.account_period_code,gl_details.trans_type,gl_details.post_flag,gl_details.debit_amt,gl_details.credit_amt,gl_details.ref_no,gl_details.ref_date,gl_details.description,c.name as bank_name,companies.name as company_name,companies.company_cd as company_code FROM gl_details join gl_accounts c on c.id=gl_details.gl_account_id
  # inner join companies on companies.id = gl_details.company_id WHERE (gl_details.[trans_flag] = 'A') AND #{condition}
  #for XML path('journal_register'),type,elements xsinil)for XML path('journal_registers'))as xml)as xmlcol
  #",criteria.user_id,criteria.str1[0,8],criteria.str2[0,8],criteria.multiselect1.length,criteria.multiselect1,
  #        criteria.dt1,criteria.dt2,
  #        criteria.str3, criteria.str4, criteria.multiselect2.length,criteria.multiselect2,                                          
  #        criteria.str5, criteria.str6, criteria.multiselect3.length,criteria.multiselect3])[0].xmlcol
  #    sql_query.commit_db_transaction 
  #    list
  #  end
  
  def self.journal_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_journal_register
           '#{criteria.user_id}',
           '#{criteria.str1[0,8]}',      '#{criteria.str2[0,8]}',   '#{criteria.multiselect1}' ,
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}' ,
           '#{criteria.str3}',           '#{criteria.str4}',        '#{criteria.multiselect2}',
           '#{criteria.str5}',           '#{criteria.str6}',        '#{criteria.multiselect3}' ")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.bank_payment_format(id) 
    sql_query = ActiveRecord::Base.connection();
    sql_query.begin_db_transaction
    payment = GeneralLedger::BankTransaction.active.find_by_sql ["
      (select vendors.name as name ,vendors.address1 as address1,vendors.address2 as address2,vendors.city as city,vendors.state as state,vendors.zip as zip,vendors.phone as phone,vendors.fax as fax,vendors.country as country,
       bank_transactions.trans_flag,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code,post_flag,
	            (Case When bank_transactions.clear_flag in ('N')  
                       Then ('Not clear')
                     Else ('Cleared') 
                     End) as clear_flag,
                    action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,vendors.code as account_code,deposit_no,	
	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
	            serial_no,banks.name as bank_name,banks.code as bank_code,companies.name as company_name,companies.company_cd as company_code  from bank_transactions
                    left outer join types on (
		             types.type_cd = 'bank_payment'
		             and types.subtype_cd = 'account_type'
		             and bank_transactions.account_flag = types.value 
                            )
                            inner join companies on companies.id = bank_transactions.company_id 
                            inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
                            left outer join banks on gl_accounts.bank_id = banks.id
                            join vendors on vendors.id = bank_transactions.account_id and 
                            account_flag = 'V' and trans_type = 'PAYM' where bank_transactions.id=?
                         
      )
    union all
    (select customers.name as name,customers.address1 as address1,customers.address2 as address2,customers.city as city,customers.state as state,customers.zip as zip,customers.phone1 as phone,customers.fax1 as fax,customers.country as country,
     bank_transactions.trans_flag,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code,post_flag,
                  (Case When bank_transactions.clear_flag in ('N')  
                       Then ('Not clear')
                   Else ('Cleared') 
                   End) as clear_flag,
                   action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,customers.code as account_code,deposit_no,bank_transactions.BANK_ID,
                   debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,serial_no,banks.name as bank_name,banks.code as bank_code,
                   companies.name as company_name,companies.company_cd as company_code  from bank_transactions
                   left outer join types on (
		             types.type_cd = 'bank_payment'
		             and types.subtype_cd = 'account_type'
		             and bank_transactions.account_flag = types.value 
                            )
                         inner join companies on companies.id = bank_transactions.company_id 
                         inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
                         left outer join banks on gl_accounts.bank_id = banks.id
                         join customers on customers.id = bank_transactions.account_id and account_flag = 'C' and  trans_type = 'PAYM' where bank_transactions.id=?

    )

    union all
    (select gl_accounts.name as name,'','','','','','','','',
     bank_transactions.trans_flag,bank_transactions.trans_bk,trans_no,trans_date,check_date,clear_date,account_period_code,post_flag,
                    (Case When bank_transactions.clear_flag in ('N')  
                       Then ('Not clear')
                     Else ('Cleared') 
                     End) as clear_flag,action_flag,types.description as account_flag,trans_type,bank_transactions.payment_type,g.code as account_code,deposit_no,	
	            bank_transactions.BANK_ID,debit_amt,credit_amt,check_no,bank_transactions.remarks,ref_no,payto_name,comments,	
	            serial_no,banks.name as bank_name,banks.code as bank_code,
                    companies.name as company_name,companies.company_cd as company_code  from bank_transactions
                    left outer join types on (
		             types.type_cd = 'bank_payment'
		             and types.subtype_cd = 'account_type'
		             and bank_transactions.account_flag = types.value 
                            )
                    inner join gl_accounts on gl_accounts.id = bank_transactions.bank_id
                    inner join gl_accounts g on g.id = bank_transactions.account_id
                    inner join companies on companies.id = bank_transactions.company_id 
                    left outer join banks on gl_accounts.bank_id = banks.id  and account_flag = 'G' and  trans_type = 'PAYM' where bank_transactions.id=? 
    )",id,id,id]
    payment_lines = GeneralLedger::BankTransactionLine.active.find(:all,
      :joins=>"",
      :conditions =>["bank_transaction_lines.bank_transaction_id = ?",id],
      :select =>" trans_bk,trans_no,trans_date,debit_amt,credit_amt,description,serial_no                             
      ")
    sql_query.commit_db_transaction
    return payment,payment_lines
  end  
  
  #Bank balance report added on  21 march 2011 by Minal Jain
  #  def self.bank_balance_report(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
  #    GeneralLedger::BankTransaction.active.find_by_sql [ "SELECT a.trans_date, 
  #                banks.code as bank_code,banks.name as bank_name,
  #		(select ( isnull(sum(credit_amt),0) - isnull(sum(debit_amt),0)) 
  #		 from bank_transactions
  #		 where trans_date <  a.trans_date
  #                 AND bank_transactions.account_flag != 'B'
  #		 and bank_id = a.bank_id) as begning_bal,
  #	sum(a.credit_amt) as receipt_amt, 
  #	sum(a.debit_amt) as payment_amt,
  #		((select ( isnull(sum(credit_amt),0) - isnull(sum(debit_amt),0) )
  #		 from bank_transactions 
  #		 where trans_date <  a.trans_date
  #             	AND bank_transactions.account_flag != 'B'
  #		 and bank_id = a.bank_id) + sum(credit_amt) - sum(debit_amt)) as closing_bal
  #	
  #FROM bank_transactions a, banks
  #WHERE a.bank_id = banks.id AND 
  #         a.company_id in (select company_id from user_companies where user_id=?)  
  #	AND (a.account_period_code between ? and ? AND (0 =? or a.account_period_code in (?))) 
  #	AND a.trans_date between ? and ? 
  #	AND (banks.code between ? and ? AND (0 =? or banks.code in (?))) 
  #       	AND a.account_flag != 'B'
  #	GROUP BY a.trans_date, banks.code, a.bank_id ,banks.name ",
  #      criteria.user_id,
  #      criteria.str1[0,8],criteria.str2[0,8],criteria.multiselect1.length,criteria.multiselect1,
  #      criteria.dt1,criteria.dt2,
  #      criteria.str3, criteria.str4, criteria.multiselect2.length,criteria.multiselect2
  #    ]
  #
  #  end

  def self.bank_balance_report(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_bank_balance_report
           '#{criteria.user_id}',
           '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}' ,
           '#{criteria.str1[0,8]}',      '#{criteria.str2[0,8]}',   '#{criteria.multiselect1}' ,
           '#{criteria.str3}',           '#{criteria.str4}',        '#{criteria.multiselect2}' ")
    sql_query.commit_db_transaction 
    list
  end
end
