class GeneralLedger::Bank < ActiveRecord::Base
  #require 'has_finder'
  include UserStamp
  include Dbobject
  include GenericSelects
  include Accounts::GlAccountLib

  attr_accessor :current_balance

  validates_presence_of :gl_category_id,  :message => "does not exist" 
  validates_presence_of :code,  :message => "does not exist" 
  validates_uniqueness_of :code, :message=>" is duplicate!!!"  
  validates_numericality_of  :credit_limit, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
  validates_length_of :name,:address1, :address2, :maximum=>40, :allow_nil=>true ,:message=>" cannot be more than 40 chars"  
  validates_length_of :bank_acct_no, :transit_no, :contact_nm,:allow_nil=>true , :maximum=>30, :message=>" cannot be more than 30 chars" 
  validates_length_of :city,:country, :maximum=>20,:allow_nil=>true , :message=>" cannot be more than 20 chars"   
  validates_length_of :zip, :maximum=>15,:allow_nil=>true , :message=>" cannot be more than 15 chars"   
  validates_length_of :state, :maximum=>5, :allow_nil=>true ,:message=>" cannot be more than 5 chars" 
  validates_length_of :balance_type, :maximum=>2, :allow_nil=>true ,:message=>" cannot be more than 2 chars" 
  validates_length_of :account_type, :maximum=>2,:allow_nil=>true , :message=>" cannot be more than 2 chars" 
  validates_associated :gl_category
 
  belongs_to :gl_category
  has_one :gl_account
  # has_many :bank_transactions , :dependent => :destroy
  has_many :bank_checks , :dependent => :destroy , :extend=>ExtendAssosiation


  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = bank_checks.find_or_build(id) if line_doc.name == 'bank_check'
    line.apply_attributes(line_doc) if line
  end
 
  def apply_codes(doc)
    gl_category_code = parse_xml(doc/'gl_category_id') if (doc/'gl_category_id').first 
    gl_category = GeneralLedger::GlCategory.find_by_code(gl_category_code)  if gl_category_code
    self.gl_category_id = gl_category.id if gl_category
  end
  
  def add_line_errors_to_header
    add_line_item_errors(bank_checks) if bank_checks
  end

  def self.fetch_bank(bank_id)
    #    gl_account = GeneralLedger::GlAccount.find_by_id(bank_id) 
    gl_account = GeneralLedger::GlAccount.find_by_sql ["select * from gl_accounts where trans_flag = 'A' and ( code like ? or id like ? )", '%'+bank_id.to_s+'%','%'+bank_id.to_s+'%']
    bank = gl_account[0].bank if gl_account[0]
    bank
  end   
  
end
