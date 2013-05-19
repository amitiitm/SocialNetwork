class Vendor::VendorReport < ActiveRecord::Base
  include General
  require'linguistics'
 
  def self.invoice_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_vendor_invoice_register
                                                          #{criteria.user_id},
                                                          '#{criteria.str1[0,8]}', '#{criteria.str2[0,8]}',    '#{criteria.multiselect1}',
                                                          '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
                                                          '#{criteria.str3}',      '#{criteria.str4}',         '#{criteria.multiselect2}',
                                                          '#{criteria.str5[0,4]}', '#{criteria.str6[0,4]}',    '#{criteria.multiselect5}',
                                                          '#{criteria.str7[0,1]}', '#{criteria.str8[0,1]}',    '#{criteria.multiselect6}',
                                                          '#{criteria.str9}',      '#{criteria.str10}',        '#{criteria.multiselect3}',
                                                          '#{criteria.dt3.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',       '#{criteria.dt4.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
                                                          '#{criteria.str11}',      '#{criteria.str12}',        '#{criteria.multiselect4}'")
    sql_query.commit_db_transaction
    list[0]['xmlcol']
  end

  def self.payment_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_vendor_payment_register
                                                          #{criteria.user_id},
                                                          '#{criteria.str1[0,8]}',  '#{criteria.str2[0,8]}',   '#{criteria.multiselect1}',
                                                          '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',        '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
                                                          '#{criteria.str3}',       '#{criteria.str4}',        '#{criteria.multiselect2}',
                                                          '#{criteria.str5}',       '#{criteria.str6}',        '#{criteria.multiselect3}',
                                                          '#{criteria.str7}',       '#{criteria.str8}',        '#{criteria.multiselect5}',
                                                          '#{criteria.str9}',       '#{criteria.str10}',       '#{criteria.multiselect4}'")
    sql_query.commit_db_transaction
    list[0]['xmlcol']
  end

  def self.credit_invoice_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_vendor_credit_invoice_register
                                                          #{criteria.user_id},
                                                          '#{criteria.str1[0,8]}',  '#{criteria.str2[0,8]}',  '#{criteria.multiselect1}',
                                                          '#{criteria.str3}',       '#{criteria.str4}',       '#{criteria.multiselect5}',
                                                          '#{criteria.dt1.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',        '#{criteria.dt2.to_datetime.strftime('%m-%d-%Y %H:%M:%S')}',
                                                          '#{criteria.str5}',       '#{criteria.str6}',       '#{criteria.multiselect2}',
                                                          '#{criteria.str7}',       '#{criteria.str8}',       '#{criteria.multiselect3}',
                                                          '#{criteria.str9}',       '#{criteria.str10}',      '#{criteria.multiselect4}',
                                                          '#{criteria.str11}',      '#{criteria.str12}',      '#{criteria.multiselect6}'")
    sql_query.commit_db_transaction
    list[0]['xmlcol']
  end
    
  #   def self.vendor_aging_detail(doc)
  #   criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
  #   mstr_temp_table = []
  #   li_group1 = 30
  #   li_group2 = 60
  #   li_group3 = 90
  #   ll_serial_no = 0
  ##   ls_rep_crit1 = criteria.str9
  ##   if(ls_rep_crit1 == 'G')
  ##    ls_credit_aging = 'Y'
  ##   else
  ##    ls_credit_aging = 'N'
  ##   end
  #    ls_credit_aging = 'Y'
  #   if(criteria.str5 == '' or criteria.str5 == nil)
  #      criteria.str5 = criteria.str6
  #   end
  #   if(criteria.dt1.to_date.to_s == '1990-01-01')
  #     criteria.dt1 = criteria.dt2
  #   end
  #   if(criteria.dt3.to_date.to_s == '1990-01-01')
  #     criteria.dt3 = criteria.dt4
  #   end
  #  if(criteria.str5 != '' and criteria.str5 != 'zzzz')
  #    ac_period_obj = Setup::AccountPeriod.find_by_sql(["select to_date as to_dt from account_periods where code = ? ",criteria.str5 ])
  #    criteria.dt1 = ac_period_obj.first.to_dt if ac_period_obj.first
  #  end
  #  condition = convert_sql_to_db_specific("(vendor_invoices.company_id in(select company_id from user_companies where user_id = ?)) AND
  #                                   (vendor_categories.code between ? and ? AND (0 =? or vendor_categories.code in (?))) AND
  #                                   (vendors.code between ? and ? and (0 =? or vendors.code in (?))) AND
  #                                   (vendor_invoices.account_period_code <= nvl(rtrim(ltrim(?)),vendor_invoices.account_period_code)) AND
  #                                   (vendor_invoices.trans_date <= ?) AND
  #                                   (vendor_invoices.inv_date <= ?) AND
  #                                   (vendor_invoices.trans_flag = 'A')")
  #   @invoices = Vendor::VendorInvoice.find(:all,
  #                   :joins =>"inner join vendors  on vendors.id = vendor_invoices.vendor_id
  #                             inner join vendor_categories on vendor_categories.id = vendors.vendor_category_id
  #                             inner join companies on companies.id = vendor_invoices.company_id",
  #                   :conditions =>[condition,
  #                                   criteria.user_id,
  #                                   criteria.str1, criteria.str2,   criteria.multiselect1.length, criteria.multiselect1,
  #                                   criteria.str3, criteria.str4,   criteria.multiselect2.length, criteria.multiselect2,
  #                                   criteria.str5,
  #                                   criteria.dt1,
  #                                   criteria.dt3],
  #                   :select =>" vendor_invoices.trans_bk,vendor_invoices.trans_no,vendor_invoices.trans_date,
  #                               vendor_invoices.inv_amt,vendor_invoices.due_date,
  #                               vendor_invoices.balance_amt,vendor_invoices.sale_date,vendor_invoices.term_code,
  #                               vendor_invoices.purchaseperson_code,vendors.code as vendor_code,companies.company_cd as company_code,
  #                               vendors.code as vendor_code,vendors.name as vendor_name,vendors.city,vendors.phone,
  #                               vendors.fax,vendor_categories.code as vendor_catagory_code",
  #                   :order =>"  vendor_catagory_code ASC,vendor_name ASC,trans_date ASC,trans_no ASC"
  #                   )
  #   @invoices.each { |invoice|
  #     if(invoice)
  #         ls_inv_bk = invoice.trans_bk
  #         ls_inv_no = invoice.trans_no
  #         ldt_inv_dt = invoice.trans_date
  #         ldec_inv_amt = invoice.inv_amt
  #         ldt_due_dt = invoice.due_date
  #         ldec_balance_amt = invoice.balance_amt
  #         ldt_sale_dt = invoice.sale_date
  #    else
  #      break
  #    end
  #    ldec_current_amt = 0
  #    ldec_group1_amt  = 0
  #    ldec_group2_amt  = 0
  #    ldec_group3_amt  = 0
  #    ldec_group4_amt  = 0
  #    ldec_credit_amt  = 0
  #    ll_serial_no = ll_serial_no + 1
  #    ls_voucher_no = ls_inv_bk + ls_inv_no
  #    ldec_t1_amt = 0
  #    @receipt_line = Vendor::VendorPaymentLine.find_by_sql(["
  #                               select (sum(apply_amt) + sum(disctaken_amt)) as amt
  #                               from vendor_payment_lines
  #                               join companies on companies.id = vendor_payment_lines.company_id
  #                               where (trans_date <= ?) AND
  #                                     (voucher_no = ?) AND
  #                                     (voucher_date = ?)",
  #                              criteria.dt1,ls_voucher_no,ldt_inv_dt])
  #   if(@receipt_line == nil or @receipt_line.first.amt == nil)
  #       ldec_t1_amt =0
  #   else
  #       ldec_t1_amt = @receipt_line.first.amt.to_i
  #   end
  #   ldec_balance_amt = ldec_inv_amt - ldec_t1_amt
  #    li_due_days = criteria.dt1.to_date - ldt_inv_dt.to_date
  #    if(li_due_days <= 0)
  #            ldec_current_amt = ldec_balance_amt
  #    elsif(li_due_days > 0 and li_due_days <= li_group1)
  #            ldec_group1_amt = ldec_balance_amt
  #    elsif(li_due_days >= (li_group1 + 1) and (li_due_days <= li_group2))
  #            ldec_group2_amt = ldec_balance_amt
  #    elsif(li_due_days >= (li_group2 + 1) and (li_due_days <= li_group3))
  #           ldec_group3_amt = ldec_balance_amt
  #    else
  #              ldec_group4_amt = ldec_balance_amt
  #     end
  #   if(ldec_balance_amt != 0)
  #      x = Vendor::VendorAgingTable.new
  #      x.fill_temp_table(ll_serial_no,ls_inv_no,ldt_inv_dt,ldt_due_dt,li_due_days,ldec_group1_amt,
  #                        ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,ldec_credit_amt,ldec_current_amt,
  #                        ldec_inv_amt,invoice.company_code,ls_inv_bk,ldt_sale_dt,ldec_balance_amt,
  #                        invoice.vendor_code,invoice.vendor_name,invoice.city,invoice.phone,
  #                        invoice.fax,invoice.vendor_catagory_code)
  #       mstr_temp_table << x
  #   end
  #   }
  #   payment_condition= convert_sql_to_db_specific("(vendor_payments.company_id in(select company_id from user_companies where user_id = ?)) AND
  #                                   (vendor_categories.code between ? and ? AND (0 =? or vendor_categories.code in (?))) AND
  #                                   (vendors.code between ? and ? and (0 =? or vendors.code in (?))) AND
  #                                   (vendor_payments.account_period_code <= nvl(rtrim(ltrim(?)),vendor_payments.account_period_code)) AND
  #                                   (vendor_payments.trans_date <= ?) AND
  #                                   (vendor_payments.trans_flag = 'A')")
  #   @payments = Vendor::VendorPayment.find(:all,
  #                   :joins =>"inner join vendors  on vendors.id = vendor_payments.vendor_id
  #                             inner join vendor_categories on vendor_categories.id = vendors.vendor_category_id
  #                             inner join companies on companies.id = vendor_payments.company_id",
  #                   :conditions =>[payment_condition,
  #                                   criteria.user_id,
  #                                   criteria.str1, criteria.str2, criteria.multiselect1.length, criteria.multiselect1,
  #                                   criteria.str2, criteria.str3, criteria.multiselect2.length, criteria.multiselect2,
  #                                   criteria.str5,
  #                                   criteria.dt1],
  #                   :select =>" vendor_payments.trans_bk,vendor_payments.trans_no,vendor_payments.trans_date,
  #                               vendor_payments.due_date,vendor_payments.paid_amt,
  #                               vendor_payments.balance_amt,vendor_payments.term_code,
  #                               vendor_payments.purchaseperson_code,vendors.code as vendor_code,companies.company_cd as company_code,
  #                               vendors.code as vendor_code,vendors.name as vendor_name,vendors.city,vendors.phone,
  #                               vendors.fax,vendor_categories.code as vendor_catagory_code",
  #                   :order =>"  vendor_catagory_code ASC,vendor_name ASC,trans_date ASC,trans_no ASC"
  #                   )
  #   @payments.each{|payment|
  #   if(payment)
  #         ls_inv_bk = payment.trans_bk
  #         ls_inv_no = payment.trans_no
  #         ldt_inv_dt = payment.trans_date
  #         ldec_paid_amt = payment.paid_amt
  #         ldt_due_dt = payment.due_date
  #         ldec_balance_amt = payment.balance_amt
  #   else
  #     break
  #   end
  #    ldec_group1_amt  = 0
  #    ldec_group2_amt  = 0
  #    ldec_group3_amt  = 0
  #    ldec_group4_amt  = 0
  #    ldec_inv_amt = 0
  #    ldec_current_amt = 0
  #    ldec_credit_amt  = 0
  #    ll_serial_no = ll_serial_no + 1
  #    ls_voucher_no = ls_inv_bk + ls_inv_no
  #    ldec_t1_amt = 0
  #    ldec_t2_amt = 0
  #    @receipt_line = Vendor::VendorPaymentLine.find_by_sql(["
  #                               select (sum(apply_amt)) as amt
  #                               from vendor_payment_lines
  #                               join companies on companies.id = vendor_payment_lines.company_id
  #                               where (trans_date <= ?) AND
  #                                     (trans_bk = ?) AND
  #                                     (trans_no = ?) AND
  #                                     (voucher_date = ?)",
  #                             criteria.dt1,ls_inv_bk,ls_inv_no,ldt_inv_dt])
  #    if(@receipt_line == nil or @receipt_line.first.amt == nil)
  #      ldec_t1_amt =0
  #    else
  #      ldec_t1_amt = @receipt_line.first.amt.to_i
  #    end
  #    @receipt_line = Vendor::VendorPaymentLine.find_by_sql(["
  #                                select (sum(apply_amt) + sum(disctaken_amt)) as amt
  #                                from vendor_payment_lines
  #                                join companies on companies.id = vendor_payment_lines.company_id
  #                                where (trans_date <= ?) AND
  #                                      (voucher_no = ?) AND
  #                                      (voucher_date = ?)",
  #                                criteria.dt1,ls_voucher_no,ldt_inv_dt])
  #     if(@receipt_line == nil or @receipt_line.first.amt == nil)
  #      ldec_t2_amt =0
  #   else
  #      ldec_t2_amt = @receipt_line.first.amt.to_i
  #   end
  #   ldec_t1_amt = ldec_t1_amt + (ldec_t2_amt * -1)
  #   ldec_balance_amt = ldec_paid_amt - ldec_t1_amt
  #   ldec_credit_amt = ldec_balance_amt
  #   ldec_balance_amt = ldec_balance_amt * (-1)
  #   li_due_days = criteria.dt1.to_date - ldt_inv_dt.to_date
  #   if(ls_credit_aging == 'y')
  #    if(li_due_days <= 0)
  #      ldec_current_amt = ldec_balance_amt
  #    elsif(li_due_days > 0 and li_due_days <= li_group1)
  #     ldec_group1_amt = ldec_balance_amt
  #    elsif(li_due_days >= (li_group1+1) and li_due_days <= li_group2)
  #     ldec_group2_amt = ldec_balance_amt
  #    elsif(li_due_days >= (li_group2+1) and li_due_days <=li_group3)
  #      ldec_group3_amt = ldec_balance_amt
  #    else
  #      ldec_group4_amt = ldec_balance_amt
  #    end
  #   end
  #    if(ldec_balance_amt != 0)
  #         x = Vendor::VendorAgingTable.new
  #         x.fill_temp_table(ll_serial_no,ls_inv_no,ldt_inv_dt,ldt_due_dt,li_due_days,ldec_group1_amt,
  #                           ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,ldec_credit_amt,ldec_current_amt,
  #                           ldec_inv_amt,payment.company_code,ls_inv_bk,ldt_sale_dt=0,ldec_balance_amt,
  #                           payment.vendor_code,payment.vendor_name,payment.city,payment.phone,
  #                           payment.fax,payment.vendor_catagory_code)
  #          mstr_temp_table << x
  #    end
  #  }
  #   mstr_temp_table
  #  end
  
  
  #   def self.vendor_aging_detail(doc)
  #   criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
  #   mstr_temp_table = []
  #   li_group1 = 30
  #   li_group2 = 60
  #   li_group3 = 90
  #   ll_serial_no = 0
  ##   ls_rep_crit1 = criteria.str9
  ##   if(ls_rep_crit1 == 'G')
  ##    ls_credit_aging = 'Y'
  ##   else
  ##    ls_credit_aging = 'N'
  ##   end
  #    ls_credit_aging = 'Y'
  ##   if(criteria.str5 == '' or criteria.str5 == nil)
  ##      criteria.str5 = criteria.str6
  ##   end
  ###   if(criteria.dt1.to_date.to_s == '1990-01-01')
  ##   if(criteria.dt1.to_date.to_s == '01-01-1990')
  ##     criteria.dt1 = criteria.dt2
  ##   end
  ###   if(criteria.dt3.to_date.to_s == '1990-01-01')
  ##   if(criteria.dt1.to_date.to_s == '01-01-1990')
  ##     criteria.dt3 = criteria.dt4
  ##   end
  ##  if(criteria.str5 != '' and criteria.str5 != 'zzzz')
  #  if( criteria.str6 != 'zzzz')
  #    ac_period_obj = Setup::AccountPeriod.find_by_sql(["select to_date as to_dt from account_periods where code = ? ",criteria.str6 ])
  #    criteria.dt2 = ac_period_obj.first.to_dt if ac_period_obj.first
  #  end
  #  condition = convert_sql_to_db_specific("(vendor_invoices.company_id in(select company_id from user_companies where user_id = ?)) AND
  #                                   (vendor_categories.code between ? and ? AND (0 =? or vendor_categories.code in (?))) AND
  #                                   (vendors.code between ? and ? and (0 =? or vendors.code in (?))) AND
  #                                   (vendor_invoices.account_period_code <= nvl(rtrim(ltrim(?)),vendor_invoices.account_period_code)) AND
  #                                   (vendor_invoices.trans_date <= ?) AND
  #                                   (vendor_invoices.inv_date <= ?) AND
  #                                   (vendor_invoices.trans_flag = 'A')")
  #   @invoices = Vendor::VendorInvoice.find(:all,
  #                   :joins =>"inner join vendors  on vendors.id = vendor_invoices.vendor_id
  #                             inner join vendor_categories on vendor_categories.id = vendors.vendor_category_id
  #                             inner join companies on companies.id = vendor_invoices.company_id",
  #                   :conditions =>[condition,
  #                                   criteria.user_id,
  #                                   criteria.str1, criteria.str2,   criteria.multiselect1.length, criteria.multiselect1,
  #                                   criteria.str3, criteria.str4,   criteria.multiselect2.length, criteria.multiselect2,
  #                                   criteria.str6,
  #                                   criteria.dt2,
  #                                   criteria.dt4],
  #                   :select =>" vendor_invoices.trans_bk,vendor_invoices.trans_no,vendor_invoices.trans_date,
  #                               vendor_invoices.inv_amt,vendor_invoices.due_date,
  #                               vendor_invoices.balance_amt,vendor_invoices.sale_date,vendor_invoices.term_code,
  #                               vendor_invoices.purchaseperson_code,vendors.code as vendor_code,companies.company_cd as company_code,
  #                               vendors.code as vendor_code,vendors.name as vendor_name,vendors.city,vendors.phone,
  #                               vendors.fax,vendor_categories.code as vendor_catagory_code",
  #                   :order =>"  vendor_catagory_code ASC,vendor_name ASC,trans_date ASC,trans_no ASC"
  #                   )
  #   @invoices.each { |invoice|
  #     if(invoice)
  #         ls_inv_bk = invoice.trans_bk
  #         ls_inv_no = invoice.trans_no
  #         ldt_inv_dt = invoice.trans_date
  #         ldec_inv_amt = invoice.inv_amt
  #         ldt_due_dt = invoice.due_date
  #         ldec_balance_amt = invoice.balance_amt
  #         ldt_sale_dt = invoice.sale_date
  #    else
  #      break
  #    end
  #    ldec_current_amt = 0
  #    ldec_group1_amt  = 0
  #    ldec_group2_amt  = 0
  #    ldec_group3_amt  = 0
  #    ldec_group4_amt  = 0
  #    ldec_credit_amt  = 0
  #    ll_serial_no = ll_serial_no + 1
  #    ls_voucher_no = ls_inv_bk + ls_inv_no
  #    ldec_t1_amt = 0
  #    @receipt_line = Vendor::VendorPaymentLine.find_by_sql(["
  #                               select (sum(apply_amt) + sum(disctaken_amt)) as amt
  #                               from vendor_payment_lines
  #                               join companies on companies.id = vendor_payment_lines.company_id
  #                               where (trans_date <= ?) AND
  #                                     (voucher_no = ?) AND
  #                                     (voucher_date = ?)",
  #                              criteria.dt2,ls_voucher_no,ldt_inv_dt])
  #   if(@receipt_line == nil or @receipt_line.first.amt == nil)
  #       ldec_t1_amt =0
  #   else
  #       ldec_t1_amt = @receipt_line.first.amt.to_i
  #   end
  #   ldec_balance_amt = ldec_inv_amt - ldec_t1_amt
  #    li_due_days = criteria.dt2.to_date - ldt_inv_dt.to_date
  #    if(li_due_days <= 0)
  #            ldec_current_amt = ldec_balance_amt
  #    elsif(li_due_days > 0 and li_due_days <= li_group1)
  #            ldec_group1_amt = ldec_balance_amt
  #    elsif(li_due_days >= (li_group1 + 1) and (li_due_days <= li_group2))
  #            ldec_group2_amt = ldec_balance_amt
  #    elsif(li_due_days >= (li_group2 + 1) and (li_due_days <= li_group3))
  #           ldec_group3_amt = ldec_balance_amt
  #    else
  #              ldec_group4_amt = ldec_balance_amt
  #     end
  #   if(ldec_balance_amt != 0)
  #      x = Vendor::VendorAgingTable.new
  #      x.fill_temp_table(ll_serial_no,ls_inv_no,ldt_inv_dt,ldt_due_dt,li_due_days,ldec_group1_amt,
  #                        ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,ldec_credit_amt,ldec_current_amt,
  #                        ldec_inv_amt,invoice.company_code,ls_inv_bk,ldt_sale_dt,ldec_balance_amt,
  #                        invoice.vendor_code,invoice.vendor_name,invoice.city,invoice.phone,
  #                        invoice.fax,invoice.vendor_catagory_code)
  #       mstr_temp_table << x
  #   end
  #   }
  #   payment_condition= convert_sql_to_db_specific("(vendor_payments.company_id in(select company_id from user_companies where user_id = ?)) AND
  #                                   (vendor_categories.code between ? and ? AND (0 =? or vendor_categories.code in (?))) AND
  #                                   (vendors.code between ? and ? and (0 =? or vendors.code in (?))) AND
  #                                   (vendor_payments.account_period_code <= nvl(rtrim(ltrim(?)),vendor_payments.account_period_code)) AND
  #                                   (vendor_payments.trans_date <= ?) AND
  #                                   (vendor_payments.trans_flag = 'A')")
  #   @payments = Vendor::VendorPayment.find(:all,
  #                   :joins =>"inner join vendors  on vendors.id = vendor_payments.vendor_id
  #                             inner join vendor_categories on vendor_categories.id = vendors.vendor_category_id
  #                             inner join companies on companies.id = vendor_payments.company_id",
  #                   :conditions =>[payment_condition,
  #                                   criteria.user_id,
  #                                   criteria.str1, criteria.str2, criteria.multiselect1.length, criteria.multiselect1,
  #                                   criteria.str2, criteria.str3, criteria.multiselect2.length, criteria.multiselect2,
  #                                   criteria.str6,
  #                                   criteria.dt2],
  #                   :select =>" vendor_payments.trans_bk,vendor_payments.trans_no,vendor_payments.trans_date,
  #                               vendor_payments.due_date,vendor_payments.paid_amt,
  #                               vendor_payments.balance_amt,vendor_payments.term_code,
  #                               vendor_payments.purchaseperson_code,vendors.code as vendor_code,companies.company_cd as company_code,
  #                               vendors.code as vendor_code,vendors.name as vendor_name,vendors.city,vendors.phone,
  #                               vendors.fax,vendor_categories.code as vendor_catagory_code",
  #                   :order =>"  vendor_catagory_code ASC,vendor_name ASC,trans_date ASC,trans_no ASC"
  #                   )
  #   @payments.each{|payment|
  #   if(payment)
  #         ls_inv_bk = payment.trans_bk
  #         ls_inv_no = payment.trans_no
  #         ldt_inv_dt = payment.trans_date
  #         ldec_paid_amt = payment.paid_amt
  #         ldt_due_dt = payment.due_date
  #         ldec_balance_amt = payment.balance_amt
  #   else
  #     break
  #   end
  #    ldec_group1_amt  = 0
  #    ldec_group2_amt  = 0
  #    ldec_group3_amt  = 0
  #    ldec_group4_amt  = 0
  #    ldec_inv_amt = 0
  #    ldec_current_amt = 0
  #    ldec_credit_amt  = 0
  #    ll_serial_no = ll_serial_no + 1
  #    ls_voucher_no = ls_inv_bk + ls_inv_no
  #    ldec_t1_amt = 0
  #    ldec_t2_amt = 0
  #    @receipt_line = Vendor::VendorPaymentLine.find_by_sql(["
  #                               select (sum(apply_amt)) as amt
  #                               from vendor_payment_lines
  #                               join companies on companies.id = vendor_payment_lines.company_id
  #                               where (trans_date <= ?) AND
  #                                     (trans_bk = ?) AND
  #                                     (trans_no = ?) AND
  #                                     (voucher_date = ?)",
  #                             criteria.dt2,ls_inv_bk,ls_inv_no,ldt_inv_dt])
  #    if(@receipt_line == nil or @receipt_line.first.amt == nil)
  #      ldec_t1_amt =0
  #    else
  #      ldec_t1_amt = @receipt_line.first.amt.to_i
  #    end
  #    @receipt_line = Vendor::VendorPaymentLine.find_by_sql(["
  #                                select (sum(apply_amt) + sum(disctaken_amt)) as amt
  #                                from vendor_payment_lines
  #                                join companies on companies.id = vendor_payment_lines.company_id
  #                                where (trans_date <= ?) AND
  #                                      (voucher_no = ?) AND
  #                                      (voucher_date = ?)",
  #                                criteria.dt2,ls_voucher_no,ldt_inv_dt])
  #     if(@receipt_line == nil or @receipt_line.first.amt == nil)
  #      ldec_t2_amt =0
  #   else
  #      ldec_t2_amt = @receipt_line.first.amt.to_i
  #   end
  #   ldec_t1_amt = ldec_t1_amt + (ldec_t2_amt * -1)
  #   ldec_balance_amt = ldec_paid_amt - ldec_t1_amt
  #   ldec_credit_amt = ldec_balance_amt
  #   ldec_balance_amt = ldec_balance_amt * (-1)
  #   li_due_days = criteria.dt2.to_date - ldt_inv_dt.to_date
  #   if(ls_credit_aging == 'y')
  #    if(li_due_days <= 0)
  #      ldec_current_amt = ldec_balance_amt
  #    elsif(li_due_days > 0 and li_due_days <= li_group1)
  #     ldec_group1_amt = ldec_balance_amt
  #    elsif(li_due_days >= (li_group1+1) and li_due_days <= li_group2)
  #     ldec_group2_amt = ldec_balance_amt
  #    elsif(li_due_days >= (li_group2+1) and li_due_days <=li_group3)
  #      ldec_group3_amt = ldec_balance_amt
  #    else
  #      ldec_group4_amt = ldec_balance_amt
  #    end
  #   end
  #    if(ldec_balance_amt != 0)
  #         x = Vendor::VendorAgingTable.new
  #         x.fill_temp_table(ll_serial_no,ls_inv_no,ldt_inv_dt,ldt_due_dt,li_due_days,ldec_group1_amt,
  #                           ldec_group2_amt,ldec_group3_amt,ldec_group4_amt,ldec_credit_amt,ldec_current_amt,
  #                           ldec_inv_amt,payment.company_code,ls_inv_bk,ldt_sale_dt=0,ldec_balance_amt,
  #                           payment.vendor_code,payment.vendor_name,payment.city,payment.phone,
  #                           payment.fax,payment.vendor_catagory_code)
  #          mstr_temp_table << x
  #    end
  #  }
  #   mstr_temp_table
  #  end

  def self.vendor_aging_detail(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_vendor_backdated_aging   #{criteria.user_id},    
                                                     '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
                                                     '#{criteria.dt4.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
                                                     '#{criteria.dt6.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
                                                     '#{criteria.str1}', '#{criteria.str2}',    '#{criteria.multiselect1}',
                                                     '#{criteria.str3}', '#{criteria.str4}',    '#{criteria.multiselect2}', 
                                                     '#{criteria.str6}',                                    
                                                     '#{criteria.str7}',
                                                     'D'")
    sql_query.commit_db_transaction 
    list
  end
  
  # def self.vendor_aging_summary(doc)
  #  mstr_temp_table = vendor_aging_detail(doc)
  #  summary_sort(mstr_temp_table)
  #  end

  def self.vendor_aging_summary(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_vendor_backdated_aging   #{criteria.user_id},    
                                                     '#{criteria.dt2.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
                                                     '#{criteria.dt4.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
                                                     '#{criteria.dt6.to_datetime.strftime('%Y-%m-%d %H:%M:%S')}',
                                                     '#{criteria.str1}', '#{criteria.str2}',    '#{criteria.multiselect1}',
                                                     '#{criteria.str3}', '#{criteria.str4}',    '#{criteria.multiselect2}', 
                                                     '#{criteria.str6}',                                    
                                                     '#{criteria.str7}',
                                                     'S'")
    sql_query.commit_db_transaction 
    list
  end
  
  def self.summary_sort(mstr_temp_table)
    final_table = []
    mstr_temp_table.each{ |x|
      if(final_table.empty?)
        final_table << mstr_temp_table.first
      else
        final_table.each{|y|
          if(y.vendor_code == x.vendor_code)
            y.group1_amt = y.group1_amt + x.group1_amt
            y.group2_amt = y.group2_amt + x.group2_amt
            y.group3_amt = y.group3_amt + x.group3_amt
            y.group4_amt = y.group4_amt + x.group4_amt
            y.balance_amt = y.balance_amt + x.balance_amt
            y.credit_amt = y.credit_amt + x.credit_amt
            y.current_amt = y.current_amt + x.current_amt
            break
          elsif((final_table.index(y) + 1) == final_table.length and final_table.last.vendor_code != x.vendor_code)
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
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_vendor_statement_register
                                                          '#{criteria.str1}',      '#{criteria.str2}',      '#{criteria.multiselect1}',
                                                          '#{criteria.str3}',      '#{criteria.str4}',      '#{criteria.multiselect2}',
                                                          '#{criteria.str5}',      '#{criteria.str6}',      '#{criteria.multiselect3}'")
    sql_query.commit_db_transaction
    list[0]['xmlcol']
  end

  def self.ledger_register(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_vendor_ledger_register
                                                          '#{criteria.str1}',      '#{criteria.str2}',      '#{criteria.multiselect1}',
                                                          '#{criteria.str3}',      '#{criteria.str4}',      '#{criteria.multiselect2}',
                                                          '#{criteria.str5}',      '#{criteria.str6}',      '#{criteria.multiselect3}'")
    sql_query.commit_db_transaction
    list[0]['xmlcol']
  end 

  def self.vendor_invoice_format(invoice_id)
    invoice = Vendor::VendorInvoice.active.find(:all,
      :joins=>"inner join vendors  on vendors.id = vendor_invoices.vendor_id
                                 inner join companies on companies.id = vendor_invoices.company_id 
                                 left outer join terms on terms.code = vendor_invoices.term_code
                                 left outer join types  on (
                                 types.type_cd = 'faap'
                                 and types.subtype_cd = 'inv_type'
                                 and vendor_invoices.inv_type = types.value )",
      :conditions =>"vendor_invoices.id = #{invoice_id}",
      :select => "trans_no,types.description as inv_type1,trans_date,due_date,inv_no,inv_date,vendor_invoices.purchaseperson_code,inv_amt,discount_amt,
                                    paid_amt,balance_amt,terms.name as term_code,item_qty,vendor_invoices.description,inv_amt as amt,
                                    companies.company_cd,companies.name as company_name,companies.address1 as company_address1,companies.address2 as company_address2,
                                    companies.city as company_city,companies.country as company_country,companies.state as company_state,
                                    companies.zip as company_zip,companies.phone as company_phone,companies.fax as company_fax,
                                    vendors.code,vendors.name,vendors.address1,vendors.address2,vendors.city,vendors.state,vendors.zip,vendors.country,
                                    vendors.phone,vendors.fax,companies.company_logo_file as company_logo_file")
    invoice_lines = Vendor::VendorInvoiceLine.active.find(:all,
      :joins=>"",
      :conditions =>"vendor_invoice_lines.vendor_invoice_id = #{invoice_id}",
      :select =>"gl_amt as amount,description
      ")
    return invoice,invoice_lines
  end
 
  def self.vendor_credit_invoice_format(payment_id)  
    payment = Vendor::VendorPayment.active.find(:all,
      :joins=>"inner join vendors  on vendors.id = vendor_payments.vendor_id
                                 inner join companies on companies.id = vendor_payments.company_id 
                                 left outer join terms on terms.code = vendor_payments.term_code
                                 left outer join types  on (
                                 types.type_cd = 'faar'
                                 and types.subtype_cd = 'credit_type'
                                 and vendor_payments.payment_type = types.value )",
      :conditions =>"vendor_payments.id = #{payment_id}",
      :select => "trans_no,trans_date,check_no,check_date,types.description as payment_type,vendor_payments.purchaseperson_code,due_date,
                                    terms.name as term_code,item_qty,vendor_payments.description,paid_amt,applied_amt,balance_amt,
                                    companies.company_cd,companies.name as company_name,companies.address1 as company_address1,companies.address2 as company_address2,
                                    companies.city as company_city,companies.country as company_country,companies.state as company_state,
                                    companies.zip as company_zip,companies.phone as company_phone,companies.fax as company_fax,
                                    vendors.code,vendors.name,vendors.address1,vendors.address2,vendors.city,vendors.state,vendors.zip,vendors.country,
                                    vendors.phone,vendors.fax,companies.company_logo_file as company_logo_file")
    payment_lines = Vendor::VendorPaymentLine.active.find(:all,
      :joins=>"",
      :conditions =>"vendor_payment_lines.vendor_payment_id = #{payment_id}",
      :select =>" original_amt,disctaken_amt,apply_amt,balance_amt,due_date,ref_no,voucher_no,voucher_date
      ")
    return payment,payment_lines
  end
 
  def self.vendor_payment_format(payment_id)
    payment = Vendor::VendorPayment.active.find(:all,
      :joins=>"inner join vendors  on vendors.id = vendor_payments.vendor_id
      ",
      :conditions =>"vendor_payments.id = #{payment_id}",
      :select => "trans_no,trans_date,check_no,check_date,vendor_payments.purchaseperson_code,due_date,
                                    vendor_payments.description,paid_amt,applied_amt,balance_amt,                              
                                    vendors.code,vendors.name,vendors.address1,vendors.address2,vendors.city,vendors.state,vendors.zip,vendors.country,
                                    vendors.phone,vendors.fax")
    payment_lines = Vendor::VendorPaymentLine.active.find(:all,
      :joins=>"",
      :conditions =>"vendor_payment_lines.vendor_payment_id = #{payment_id}",
      :select =>" original_amt,disctaken_amt,apply_amt,balance_amt,due_date,ref_no,voucher_no,voucher_date,trans_no,trans_date
      ")
    return payment,payment_lines
  end
 
  ## Prototype services for customer info screen
  def self.vendor_info_detail(doc)
    criteria = Setup::Criteria.fill_criteria_for_sp(doc/:criteria)
    user_id = parse_xml(doc/:criteria/'user_id')
    current_time = Time.new.strftime("%Y-%m-%d 00:00:00")
    account_period_code = Setup::AccountPeriod.period_from_date(Time.now).code
    sql_query = ActiveRecord::Base.connection();
    sql_query.execute "SET IMPLICIT_TRANSACTIONS OFF";
    sql_query.begin_db_transaction()
    list = ActiveRecord::Base.connection.select_all("exec sp_retail_acct_vendor_backdated_aging  
    '#{user_id}',
    '#{current_time}',  '#{current_time}','#{current_time}',
    '#{criteria.str3}', '#{criteria.str4}',    '#{criteria.multiselect2}',
    '#{criteria.str1}', '#{criteria.str2}',    '#{criteria.multiselect1}',
    '#{account_period_code}','I','S'")
    sql_query.commit_db_transaction 
    return list    
  end
end