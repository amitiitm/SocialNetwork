class GeneralLedger::BankReconciliation < ActiveRecord::Base  
  include UserStamp
  include Dbobject
  include GenericSelects

  belongs_to :bank, :foreign_key => "bank_id" 

  def add_line_errors_to_header
    
  end
end
