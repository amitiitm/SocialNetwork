class GeneralLedger::GlTransactionLine < ActiveRecord::Base
include UserStamp
include Dbobject
include General
include ClassMethods
include Accounts::GlAccountLib

  attr_accessor  :acct_flag
  validates :trans_bk,:trans_no, :trans_date,:gl_account_id, :description,:presence => true
  validates_numericality_of  :credit_amt, :debit_amt, :less_than_or_equal_to=>999999999.99,:allow_nil=>true   
  
  belongs_to :gl_transaction
  belongs_to :gl_account
  
def fill_default_detail_values
  self.debit_amt ||= nulltozero(self.debit_amt)
  self.credit_amt ||= nulltozero(self.credit_amt)
  self.post_flag ||= 'U'
end


end
