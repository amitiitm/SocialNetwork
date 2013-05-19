module Accounts::GlAccountLib  
include General
include ClassMethods  
 

def validate_journal
  raise_error( "Gl account cannot be Bank") if gl_transaction_lines.to_ary.find{|li| li.acct_flag == 'B' }
  total_debit_amt = sum_of_debit_amt
  total_credit_amt = sum_of_credit_amt
  raise_error( "Debit and Credit entries should be 0") if self.trans_flag != 'A' and (total_debit_amt !=0 or total_credit_amt != 0 )
  raise_error( "Debit amount should be equal to Credit amount") if total_debit_amt != total_credit_amt
end  

def fill_gl_account(bank)
#  gl_account = GeneralLedger::GlAccount.new
  self.code = bank['code']
  self.name =  bank['name']
  self.gl_category_id =   bank['gl_category_id']
  self.balance_type =  bank['balance_type']
  self.acct_flag = 'B'
  self.start_date =  bank['start_date']
  self.company_id =  bank['company_id']
#  gl_account.save!
end
  
def create_new_gl_account
  gl_account = GeneralLedger::GlAccount.new
  gl_account.fill_gl_account(self.attributes)
  self.gl_account = gl_account
end

def sum_of_debit_amt
  return gl_transaction_lines.applied_lines.inject(0){|sum,x| sum += x.debit_amt} if gl_transaction_lines
end

def sum_of_credit_amt
  return gl_transaction_lines.applied_lines.inject(0){|sum,x| sum += x.credit_amt} if gl_transaction_lines
end

def create_gl_postings 
  gl_postings = []
  self.gl_transaction_lines.applied_lines.each{|line|
    gl_posting_line = fill_from_gl_transaction
    if gl_posting_line
      line.fill_from_lines(gl_posting_line)
      gl_postings << gl_posting_line
    end
   }
  gl_postings
end

def fill_from_gl_transaction
  gl_posting = GeneralLedger::GlPosting.new
  gl_posting.company_id = self.company_id
  gl_posting.trans_bk = self.trans_bk
  gl_posting.trans_no = self.trans_no
  gl_posting.trans_date = self.trans_date
  gl_posting.account_period_code = self.account_period_code
  gl_posting.trans_type = self.trans_type
  gl_posting.post_flag = 'U'
  gl_posting.update_flag = 'V'  
  gl_posting.customer_vendor_id = ''
  gl_posting.module_code = JOURNAL_MODULE_CODE
  gl_posting
end

def fill_from_lines(gl_posting)
  gl_posting.ref_no = self.ref_no
  gl_posting.ref_date = self.ref_date  
  gl_posting.description = self.description
  gl_posting.serial_no =self.serial_no
  gl_posting.debit_amt = self.debit_amt
  gl_posting.credit_amt = self.credit_amt
  gl_posting.dtl_serial_no = self.serial_no
  gl_posting.gl_account_id = self.gl_account_id
end
end
