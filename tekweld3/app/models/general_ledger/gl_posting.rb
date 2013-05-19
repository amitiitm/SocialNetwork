class GeneralLedger::GlPosting < ActiveRecord::BaseWithoutTable
include General
include ClassMethods
  

  attr_accessor :company_id
  attr_accessor :update_flag
  attr_accessor :trans_bk
  attr_accessor :trans_no
  attr_accessor :trans_date
  attr_accessor :ref_no
  attr_accessor :ref_bk
  attr_accessor :ref_date
  attr_accessor :account_period_code
  attr_accessor :trans_type
  attr_accessor :description
  attr_accessor :post_flag
  attr_accessor :customer_vendor_flag
  attr_accessor :customer_vendor_id
  attr_accessor :serial_no
  attr_accessor :dtl_serial_no
  attr_accessor :dtl_description
  attr_accessor :module_code
  attr_accessor :gl_account_id
  attr_accessor :debit_amt
  attr_accessor :credit_amt

def self.show_gl_postings(trans_no,company_id,trans_bk)
   GeneralLedger::GlDetail.find_all_by_trans_no_and_company_id_and_trans_bk(trans_no,company_id,trans_bk)
end

def self.post_gl_transactions(gl_postings)  
  trans_bk = gl_postings.first.trans_bk 
  trans_no = gl_postings.first.trans_no 
  company_id = gl_postings.first.company_id 
  trans_period = gl_postings.first.account_period_code
  unpost_gl(trans_bk,trans_no,company_id,trans_period) 
  post_gl_detail(gl_postings) 
  post_summary(company_id,trans_period,gl_postings)
end

def self.unpost_gl(trans_bk,trans_no,company_id,trans_period)  
  unposted_summaries = []
  gl_details = GeneralLedger::GlDetail.find_all_by_trans_bk_and_trans_no_and_company_id_and_trans_flag(trans_bk,trans_no,company_id,'A')
  gl_accounts = list_of_gl_accounts(gl_details).uniq
  gl_accounts.each{|gl_account|
    gl_account_lines = gl_details.to_ary.find_all{|li| li.gl_account_id == gl_account}
    total_credit_amt = total_credits(gl_account_lines)
    total_debit_amt = total_debits(gl_account_lines)
# Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  
#    gl_summary = GeneralLedger::GlSummary.find_by_account_period_code_and_gl_account_id(trans_period,gl_account)
    gl_summary = GeneralLedger::GlSummary.find_by_account_period_code_and_gl_account_id(gl_details[0].account_period_code,gl_account)
    if gl_summary
      gl_summary.credit_amt -= total_credit_amt
      gl_summary.debit_amt -= total_debit_amt
      unposted_summaries << gl_summary
    end
    }
  unposted_summaries.each{|summ|  summ.save!}
  #Unpost gl_details
  gl_details.each{|li| li.destroy }
#  GeneralLedger::GlDetail.delete_posted_rows(trans_bk,trans_no)
end

def self.post_gl_detail(gl_postings) 
  gl_postings.each{|li|
    #modified on 21 JUN ( as told by Vivek sir,Praman)
#    if nulltozero(li.debit_amt) > 0 || nulltozero(li.credit_amt) > 0
    if nulltozero(li.debit_amt) != 0 || nulltozero(li.credit_amt) != 0
      gl = GeneralLedger::GlDetail.new
      li.post_detail(gl) 
      gl.save!
    end
  }  
end 

def post_detail(gl)
  gl.company_id = self.company_id if self.company_id
  gl.trans_bk = self.trans_bk if self.trans_bk
  gl.trans_no = self.trans_no if self.trans_no
  gl.trans_date = self.trans_date if self.trans_date
  gl.ref_no = self.ref_no if self.ref_no
  gl.ref_bk = self.ref_bk if self.ref_bk
  gl.ref_date = self.ref_date if self.ref_date
  gl.account_period_code = self.account_period_code if self.account_period_code
  gl.trans_type = self.trans_type if self.trans_type
  gl.description = self.description if self.description
  gl.post_flag = self.post_flag if self.post_flag 
  gl.customer_vendor_flag = self.customer_vendor_flag if self.customer_vendor_flag
  gl.customer_vendor_id = self.customer_vendor_id if self.customer_vendor_id
  gl.hdr_serial_no = self.serial_no if self.serial_no
  gl.module_code = self.module_code if self.module_code
  gl.update_flag = self.update_flag if self.update_flag
  gl.gl_account_id = self.gl_account_id if self.gl_account_id
  gl.debit_amt = self.debit_amt if self.debit_amt
  gl.credit_amt= self.credit_amt if self.credit_amt
  gl.description = self.description if self.description
  gl.dtl_serial_no = self.dtl_serial_no if self.dtl_serial_no
end

def self.post_summary(company_id,trans_period,gl_postings) 
  posted_summaries = []
  gl_accounts = list_of_gl_accounts(gl_postings).uniq
  gl_accounts.each{|gl_account|
    gl_account_lines = gl_postings.to_ary.find_all{|li| li.gl_account_id == gl_account}
    total_credit_amt = total_credits(gl_account_lines)
    total_debit_amt = total_debits(gl_account_lines)
    gl_summary = GeneralLedger::GlSummary.find_by_company_id_and_account_period_code_and_gl_account_id(company_id,trans_period,gl_account)
    if gl_summary      
      gl_summary.credit_amt += total_credit_amt
      gl_summary.debit_amt += total_debit_amt
	# Change: Praman July-04-2011 Making transaction date editable and post/unpost transaction accordingly.  	
	gl_summary.account_period_code = trans_period
    else
      gl_summary = GeneralLedger::GlSummary.new
      gl_summary.account_period_code = trans_period
      gl_summary.gl_account_id = gl_account
      gl_summary.credit_amt = total_credit_amt
      gl_summary.debit_amt = total_debit_amt
    end
    posted_summaries << gl_summary
    }
    
  posted_summaries.each{|summ|  summ.save!}
# 
end

def self.list_of_gl_accounts(gl_postings)
#  gl_accounts = []
  return gl_postings.inject([]){|gl_accounts,li| gl_accounts << li.gl_account_id}
#  gl_accounts 
end

def self.total_credits(gl_postings)
  return gl_postings.inject(0){|sum,x| sum += nulltozero(x.credit_amt) } if gl_postings
end

def self.total_debits(gl_postings)
   return gl_postings.inject(0){|sum2,x| sum2 += nulltozero(x.debit_amt) } if gl_postings
end
end
