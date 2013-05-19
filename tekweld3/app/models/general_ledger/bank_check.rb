class GeneralLedger::BankCheck < ActiveRecord::Base
include UserStamp
include Dbobject
include GenericSelects
#include Accounts::GlAccountLib

belongs_to :bank

validates_presence_of :bank_id,:payment_type, :message => "does not exist" 
  
before_validation do
  errors.add(:check_from,"Check From cannot be greater than Check To") if self.check_from.to_i > self.check_to.to_i
end
end
