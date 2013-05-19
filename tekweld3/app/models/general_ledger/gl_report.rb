class GeneralLedger::GlReport < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  
  #  def self.general_ledger_summary(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #    GeneralLedger::GlDetail.find_by_sql(["select CAST( (select(select tbl_gl_summary.* from
  #                   (SELECT x.account_period_code,
  #                          y.code,y.name, SUM(x.debit_amt) AS debit_amt,SUM(x.credit_amt) as credit_amt,
  #                          SUM(x.debit_amt)-SUM(x.credit_amt) as balance_amt 
  #                   FROM (
  #                        SELECT account_period_code,SUM(debit_amt) AS debit_amt,SUM(credit_amt) as credit_amt,gl_account_id as acct_id
  #                        FROM gl_details              
  #                        WHERE  (gl_details.company_id in(select company_id from user_companies where user_id=?)) AND
  #                                (gl_details.account_period_code between ? and ? )         
  #                        GROUP BY account_period_code, gl_account_id
  #
  #                        UNION ALL
  #                        
  #                        SELECT  account_period_code,SUM(debit_amt) AS debit_amt,SUM(credit_amt) as credit_amt,gl_account_id as acct_id
  #                        FROM gl_summaries             
  #                        INNER JOIN account_years on account_years.id = gl_summaries.gl_account_id
  #                        WHERE (gl_summaries.company_id in (select company_id from user_companies where user_id=?)) AND
  #                              (gl_summaries.account_period_code between ? and ? ) AND
  #                              ( gl_summaries.account_period_code>=account_years.from_period) AND
  #                              (gl_summaries.account_period_code < account_years.to_period) AND
  #                              ( ? between from_period and to_period)
  #                        GROUP BY account_period_code,gl_account_id,credit_amt,debit_amt
  #                        HAVING debit_amt <> credit_amt    
  #                   ) x, gl_accounts y
  #                   WHERE x.acct_id = y.id AND
  #                        (y.code  between ? and ? and (0 =? or y.code in (?)) ) 
  #                   GROUP BY x.account_period_code,y.name,y.code)as tbl_gl_summary FOR XML PATH('general_ledger'),type,elements xsinil)FOR XML PATH('general_ledgers')) AS xml) as xmlcol ",
  #                    criteria.user_id,
  #                    criteria.str1[0,8],  criteria.str2[0,8], 
  #                    criteria.user_id,
  #                    criteria.str1[0,8],  criteria.str2[0,8], 
  #                    criteria.str1[0,8],
  #                    criteria.str3,      criteria.str4,       criteria.multiselect1.length, criteria.multiselect1
  #               ])[0].xmlcol
  #  end

  def self.general_ledger_summary(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_general_ledger_summary_register
           '#{criteria.user_id}',
           '#{criteria.str1[0,8]}',      '#{criteria.str2[0,8]}',
           '#{criteria.str3}',           '#{criteria.str4}',        '#{criteria.multiselect1}' ")
    sql_query.commit_db_transaction 
    list[0]['xmlcol']
  end
  
  #  def self.general_ledger_detail(doc)
  #      criteria = Setup::Criteria.fill_criteria(doc/:criteria)    
  #      sql = "
  #                        SELECT y.account_period_code as account_period_code,  
  #                               y.trans_bk as trans_bk,   
  #                               y.trans_no as trans_no,   
  #                               y.trans_date as trans_date,   
  #                               y.ref_no as ref_no,   
  #                               y.ref_date as  ref_date,         
  #                               y.ref_account_name,
  #                               y.ref_account_code,
  #                               y.description,
  #                               nvl(y.debit_amt,0) as debit_amt,   
  #                               nvl(y.credit_amt,0) as credit_amt ,   
  #                               gl_accounts.code as gl_account_code,   
  #                               gl_accounts.name as gl_account_name,   
  #                               gl_categories.code as gl_category_code,   
  #                               nvl(x.debit_amt,0) - nvl(x.credit_amt,0) as obal_amt  ,
  #                               account_type1
  #                        FROM gl_accounts  
  #                        LEFT OUTER JOIN (
  #                              select gl_account_id as account_id,SUM(debit_amt) AS debit_amt,SUM(credit_amt) as credit_amt
  #                              from gl_summaries
  #                              join gl_accounts on gl_accounts.id = gl_summaries.gl_account_id
  #                              ,account_years
  #                              where  gl_summaries.company_id in(select company_id from user_companies where user_id=?) AND 
  #                                    (? between account_years.from_period and  account_years.to_period) AND
  #                                    (gl_summaries.account_period_code < ?) AND
  #                                    (gl_accounts.code between ? and ? and (0 =? or gl_accounts.code in (?))) AND
  #                                    (gl_summaries.account_period_code >= account_years.from_period) 
  #                              group by gl_account_id
  #                              having sum(debit_amt) <> sum(credit_amt)
  #                         )x ON x.account_id = gl_accounts.id 
  #                        LEFT OUTER JOIN(
  #                              select gl_details.gl_account_id as account_id,
  #                                      trans_bk,trans_no,trans_date,gl_details.description as description,
  #                                      ref_bk, ref_no, ref_date, 
  #                                      debit_amt, credit_amt, 
  #                                      gl_details.account_period_code,
  #                                      post_flag,0 as op_Db, 0 as op_cr,
  #                                      customer_vendor_id,	     
  #                                      ltrim(rtrim(nvl(vendors.name,'')) || 
  #                                             rtrim(nvl(customers.name,'')) || 
  #                                              rtrim(nvl(gl_x.name,''))
  #                                       ) as ref_account_name,
  #                                       ltrim(rtrim(nvl(vendors.code,'')) || 
  #                                              rtrim(nvl(customers.code,'')) || 
  #                                              rtrim(nvl(gl_x.code,'')) 
  #                                        ) as ref_account_code , types.description as account_type1
  #                              from gl_details
  #                              left outer join vendors on 
  #                                   gl_details.customer_vendor_id = vendors.id and gl_details.customer_vendor_flag = 'V'
  #                              left outer join customers ON 
  #                                   gl_details.customer_vendor_id = customers.id and gl_details.customer_vendor_flag = 'C'
  #                             left outer join types ON 
  #                                   gl_details.customer_vendor_flag = types.value and types.type_cd = 'bank_payment'
  #                              left outer join gl_accounts gl_x ON 
  #                                   gl_details.gl_account_id = gl_x.id
  #                              inner join gl_accounts gl_y ON
  #                                   gl_y.id = gl_details.gl_account_id
  #                              where gl_details.company_id in(select company_id from user_companies where user_id=?) AND
  #                                    (gl_y.code between ? and ? and (0 =? or  gl_y.code in (?))) AND
  #                                    (gl_details.account_period_code between ? and ? ) 
  #                        )y on ( y.account_id = gl_accounts.id)     
  #                        LEFT OUTER JOIN gl_categories on gl_categories.id = gl_accounts.gl_category_id  
  #                        WHERE (gl_accounts.code between ? and ? AND (0 =? or gl_accounts.code in (?))) AND
  #                              (nvl(y.debit_amt,0)+nvl(y.credit_amt,0)+nvl(x.debit_amt,0) + nvl(x.credit_amt,0)) <> 0
  #                        ORDER BY gl_account_code,trans_date,trans_bk,trans_no "
  #      sql = convert_sql_to_db_specific(sql)
  #      @details = GeneralLedger::GlDetail.find_by_sql([sql ,       
  #                  criteria.user_id,      
  #                  criteria.str1,
  #                  criteria.str1,
  #                  criteria.str3, criteria.str4, criteria.multiselect1.length, criteria.multiselect1,
  #                  criteria.user_id,
  #                  criteria.str3, criteria.str4, criteria.multiselect1.length, criteria.multiselect1,
  #                  criteria.str1, criteria.str2,
  #                  criteria.str3, criteria.str4, criteria.multiselect1.length, criteria.multiselect1 
  #                  ] )
  #
  #      mstr_temp_tble = []
  #      old_gl_code = temp_gl_code = 0
  #      curr = 0 
  #      balance_amt = 0
  #      @details.each { |detail|
  #        temp_gl_code = detail.gl_account_code
  #        if(temp_gl_code != old_gl_code )
  #          old_gl_code = detail.gl_account_code
  #          curr = detail.debit_amt - detail.credit_amt + (detail.obal_amt).to_i                
  #          balance_amt = curr
  #        elsif(temp_gl_code == old_gl_code)
  #          curr = detail.debit_amt - detail.credit_amt
  #          balance_amt = balance_amt + curr                 
  #        end  
  #        if(detail.account_period_code == '' || detail.account_period_code == nil)
  #          detail.ref_account_name = 'Opening Balance : '
  #          balance_amt = 0
  #          if(detail.obal_amt.to_i > 0)
  #            detail.debit_amt = detail.obal_amt.to_i
  #          end
  #          if(detail.obal_amt.to_i < 0)  
  #            detail.credit_amt = detail.obal_amt.to_i
  #          end
  #        end           
  #      x= GeneralLedger::Gl_Detail_Report_Table.new
  #      x.fill_temp_table(detail,balance_amt)
  #      mstr_temp_tble << x      
  #      }
  #    mstr_temp_tble
  #  end 

  def self.general_ledger_detail(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_general_ledger_detail_report
           '#{criteria.user_id}',
           '#{criteria.str1[0,8]}',      '#{criteria.str2[0,8]}',
           '#{criteria.str3}',           '#{criteria.str4}',        '#{criteria.multiselect1}' ")
    sql_query.commit_db_transaction 
    list[0]['xmlcol']
  end

  #  def self.trial_balance_summary(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #    sql = "select CAST( (select(select tbl_balance_summary.* from
  #                (Select y.code as gl_account_code,x.gl_account_id, y.name ,
  #                      case when sum(x.op_db - x.op_Cr) > 0 Then sum(x.op_db - x.op_Cr) else 0 end as op_db ,
  #                      Case when sum(x.op_db - x.op_Cr) < 0 Then sum(x.op_Cr - x.op_db) else 0 end as op_cr, 
  #                      Case when sum(x.tr_db - x.tr_cr) > 0 Then sum(x.tr_db - x.tr_cr) else 0 end as tr_db , 
  #                      Case when sum(x.tr_db - x.tr_cr) < 0 Then sum(x.tr_cr - x.tr_db) else 0 end as tr_cr,
  #                      Case when sum((x.op_db + tr_db) - (x.op_Cr + tr_Cr)) > 0 Then sum((x.op_db + tr_db) - (x.op_Cr + tr_Cr)) else 0 end as cl_db , 
  #                      Case when sum((x.op_db + tr_db) - (x.op_Cr + tr_Cr)) < 0 Then sum((x.op_Cr + tr_Cr) - (x.op_db + tr_db) ) else 0 end as cl_cr 
  #                FROM 
  #                (
  #                    Select gl_account_id, 0 as op_db, 0 as op_Cr, sum(debit_amt) as tr_db, 
  #                           sum(credit_amt) as tr_cr
  #                    from gl_details
  #                    inner join gl_accounts on
  #                          gl_details.gl_account_id = gl_accounts.id
  #                    where gl_details.company_id in(select company_id from user_companies where user_id=?) and 
  #                          (gl_accounts.code between ? and ? and (0 =? or  gl_accounts.code in (?)))  and 
  #                          account_period_code between ? and ?
  #                    group by gl_account_id
  #
  #                  union all 
  #                    Select gl_account_id, sum(debit_amt) as op_db, sum(credit_amt) as op_Cr, 0 as tr_db , 0 as tr_cr
  #                    from gl_summaries
  #                    inner join gl_accounts on
  #                          gl_summaries.gl_account_id = gl_accounts.id
  #                    ,account_years
  #                    where gl_summaries.company_id in (select company_id from user_companies where user_id = ?)  and 
  #                          (gl_accounts.code between ? and ? and (0 =? or  gl_accounts.code in (?))) and 
  #                          account_period_code >= from_period and 
  #                          account_period_code < ? and 
  #                          ? between from_period and to_period
  #                    group by gl_account_id 
  #                    having sum(debit_amt) <> sum(Credit_amt)
  #                ) x, gl_accounts y 
  #                Where x.gl_account_id = y.id 
  #                Group by x.gl_account_id, y.name, y.code)as tbl_balance_summary FOR XML PATH('general_ledger'),type,elements xsinil)FOR XML PATH('general_ledgers')) AS xml) as xmlcol"
  #    sql = convert_sql_to_db_specific(sql)
  #    GeneralLedger::GlDetail.find_by_sql([sql,
  #                criteria.user_id,
  #                criteria.str3,criteria.str4,criteria.multiselect1.length, criteria.multiselect1,
  #                criteria.str1[0,8],criteria.str2[0,8],
  #                criteria.user_id,
  #                criteria.str3,criteria.str4,criteria.multiselect1.length, criteria.multiselect1,
  #                criteria.str1[0,8],criteria.str2[0,8]])[0].xmlcol
  #  end

  def self.trial_balance_summary(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_trial_balance_summary_report
           '#{criteria.user_id}',
           '#{criteria.str1[0,8]}',      '#{criteria.str2[0,8]}',
           '#{criteria.str3}',           '#{criteria.str4}',        '#{criteria.multiselect1}' ")
    sql_query.commit_db_transaction 
    list[0]['xmlcol']
  end

#  def self.trial_balance_detail(doc)
#    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
#    GeneralLedger::GlDetail.find_by_sql(["select CAST( (select(select tbl_balance_detail.* from
#           (SELECT y.code,
#                  x.gl_account_id, 
#                  y.name, 
#                  case when sum(x.op_db) > sum(x.op_cr) then sum(x.op_db) - sum(x.op_cr) else 0 end as op_db ,  
#                  case when sum(x.op_db) < sum(x.op_cr) then  sum(x.op_cr) - sum(x.op_db) else 0 end as op_cr,   
#                  sum(x.tr_db) as tr_db ,  
#                  sum(x.tr_cr) as tr_cr,    
#                  Case when sum((x.op_db + tr_db) - (x.op_cr + tr_cr)) > 0 Then sum((x.op_db + tr_db) - (x.op_cr + tr_cr)) else 0 end as cl_db ,  
#                  Case when sum((x.op_db + tr_db) - (x.op_cr + tr_cr)) < 0 Then sum((x.op_cr + tr_cr) - (x.op_db + tr_db) ) else 0 end as cl_cr   
#           FROM 
#           (
#              select gl_account_id, 
#                      0 as op_db, 
#                      0 as op_cr, 
#                      sum(debit_amt) as tr_db, 
#                      sum(credit_amt) as tr_cr
#                from  gl_details
#		inner join gl_accounts on
#                      gl_details.gl_account_id = gl_accounts.id
#                where gl_details.company_id  in ( select company_id from user_companies where user_id = ?) and
#                      (gl_accounts.code between ? and ? and (0 =? or  gl_accounts.code in (?))) and
#                      account_period_code between  ? and ?
#                group by gl_account_id
#
#            union all 
#
#              select gl_account_id,  
#                     sum(debit_amt) as op_db, 
#                     sum(Credit_amt) as op_cr,
#                     0 as tr_db, 
#                     0 as tr_cr
#              from  gl_summaries
#              inner join gl_accounts on
#                    gl_summaries.gl_account_id = gl_accounts.id,
#              account_years 
#              where  gl_summaries.company_id in ( select company_id from user_companies where user_id = ?) and
#	            (gl_accounts.code between ? and ? and (0 =? or  gl_accounts.code in (?))) and 	
#                    account_period_code >= from_period  and
#                    account_period_code <  ? and 	
#                    ? between from_period and  to_period
#              group by gl_account_id 
#              having sum(debit_amt) <> sum(Credit_amt)
#          ) x, gl_accounts y 
#      WHERE  x.gl_account_id = y.id and
#             (y.code between ? and ? and (0 =? or  y.code in (?)))
#      GROUP BY x.gl_account_id, y.name,y.code)as tbl_balance_detail FOR XML PATH('general_ledger'),type,elements xsinil)FOR XML PATH('general_ledgers')) AS xml) as xmlcol",
#        criteria.user_id,
#        criteria.str3,criteria.str4,criteria.multiselect1.length, criteria.multiselect1,
#        criteria.str1[0,8],criteria.str2[0,8],
#        criteria.user_id,
#        criteria.str3,criteria.str4,criteria.multiselect1.length, criteria.multiselect1,
#        criteria.str1[0,8],criteria.str2[0,8],
#        criteria.str3,criteria.str4,criteria.multiselect1.length, criteria.multiselect1 ])[0].xmlcol
#  end

  def self.trial_balance_detail(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_trial_balance_detail_report
           '#{criteria.user_id}',
           '#{criteria.str1[0,8]}',      '#{criteria.str2[0,8]}',
           '#{criteria.str3}',           '#{criteria.str4}',        '#{criteria.multiselect1}' ")
    sql_query.commit_db_transaction 
    list[0]['xmlcol']
  end

end