class GeneralLedger::BankTransactionLine < ActiveRecord::Base
include UserStamp
include Dbobject
include GenericSelects
#include Accounts::BankTransactionLib

belongs_to :bank_transaction
belongs_to :gl_account
#att_accessor :gl_code, :gl_name
validates_presence_of :trans_bk,:trans_no, :trans_date, :gl_account_id, :serial_no, :message => "does not exist" 
validates_numericality_of  :debit_amt, :credit_amt , :less_than_or_equal_to=>999999999.99,:allow_nil=>true 

  
def fill_default_detail_values
  self.debit_amt ||= 0
  self.credit_amt ||= 0 
end

end
