class GeneralLedger::GlSetupItem < ActiveRecord::Base
 include UserStamp
  include Dbobject
  include General
  include ClassMethods
  belongs_to :gl_setup, :class_name => "GeneralLedger::GlSetup"
  
  belongs_to :purchase_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "purchase_account_id"
  belongs_to :sales_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "sales_account_id"

  validates_presence_of :item_type,  :message => "does not exist" 
#  validates_uniqueness_of :item_type, :message=>" is duplicate!!!"  

def fill_default_detail_values
  
end

end
