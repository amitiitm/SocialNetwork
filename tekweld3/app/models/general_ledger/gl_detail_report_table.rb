class GeneralLedger::Gl_Detail_Report_Table < ActiveRecord::BaseWithoutTable
  
  attr_accessor :account_period_code
  attr_accessor :trans_bk
  attr_accessor :trans_no
  attr_accessor :trans_date
  attr_accessor :ref_no
  attr_accessor :ref_date
  attr_accessor :ref_account_name
  attr_accessor :ref_account_code
  attr_accessor :debit_amt
  attr_accessor :credit_amt
  attr_accessor :gl_account_code
  attr_accessor :gl_account_name
  attr_accessor :gl_category_code
  attr_accessor :obal_amt
  attr_accessor :balance_amt
  attr_accessor :description
   
  def fill_temp_table(object,balance_amt)
    self.account_period_code = object.account_period_code
    self.trans_bk = object.trans_bk
    self.trans_no = object.trans_no
    self.trans_date = object.trans_date
    self.ref_no = object.ref_no
    self.ref_date = object.ref_date
    self.ref_account_name = object.ref_account_name  
    self.ref_account_code = object.ref_account_code 
    self.debit_amt = object.debit_amt
    self.credit_amt = object.credit_amt
    self.gl_account_code = object.gl_account_code
    self.gl_account_name = object.gl_account_name
    self.gl_category_code = object.gl_category_code
    self.obal_amt = object.obal_amt
    self.balance_amt = balance_amt  
    self.description = object.description  
        
  end
  #updated
end
