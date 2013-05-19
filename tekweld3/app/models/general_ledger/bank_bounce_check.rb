class GeneralLedger::BankBounceCheck < ActiveRecord::Base
  include General
  include UserStamp
  include Dbobject
  include Accounts::BankBounceCheckAccountsPosting
  include Accounts::BankBounceCheckGlPosting
  include Accounts::BankChargesGlPosting
  include Accounts::BankBounceCheckPaymentPosting
  include Accounts::BankBounceCheckBankPosting
 
 
  validates_presence_of :trans_bk,:trans_no, :trans_date,:account_period_code,:check_no,  :message => "does not exist" 
  
  def generate_trans_no(docu_type)
    self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,docu_type,self.class,self.company_id)
  end

  after_create() do
    Setup::Sequence.upd_book_code(self.trans_bk,'FASHBC',self.trans_no,self.company_id)  if self.trans_bk == 'VOCK' 
  end   
  
  def add_line_errors_to_header
    
  end

  def fill_default_header_values
    self.post_flag ||= 'U' 
    self.trans_flag ||= 'A' 
    self.trans_bk = 'VOCK' 
    self.action_flag = 'A'
    self.clear_flag = 'Y'
  end
  
end
