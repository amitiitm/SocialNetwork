class Vendor::VendorCategory < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  
  has_many :vendors, :class_name => 'Vendor::Vendor' , :extend=>ExtendAssosiation
#  belongs_to :gl_account_payable, :class_name => 'GeneralLedger::GlAccount', :foreign_key => 'gl_account_payable_id'
#  belongs_to :gl_account_expense, :class_name => 'GeneralLedger::GlAccount', :foreign_key => 'gl_account_expense_id'
  belongs_to :gl_account_payable,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "gl_account_payable_id"                    
  belongs_to :gl_account_expense,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "gl_account_expense_id"                    

  validates :code, :presence => true
  validates_uniqueness_of :code, :message=> ' is duplicate!!!'
  validates_length_of :code, :maximum=>25, :allow_nil=>true ,:message=> ' cannot be more than 25 chars'  

  attr_accessor  :gl_account_code
  
#  gl_account_code = self.gl_account.code
end
