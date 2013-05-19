class GeneralLedger::GlAccount < ActiveRecord::Base
require 'has_finder'
include UserStamp
include Dbobject
include GenericSelects
include Accounts::GlAccountLib

 validates_presence_of :gl_category_id, :acct_flag, :message => "does not exist" 
 validates_presence_of :code,  :message => "does not exist" 
 validates_uniqueness_of :code, :message=>" gl account code is duplicate!!!"  
 validates_length_of :acct_flag, :maximum=>1, :allow_nil=>true ,:message=>" cannot be more than 1 chars"  
 validates_length_of :code,:group1,:group2,:group3,:group4, :maximum=>18, :allow_nil=>true ,:message=>" cannot be more than 18 chars"  
 validates_length_of :balance_type, :maximum=>2, :allow_nil=>true ,:message=>" cannot be more than 2 chars"  
 validates_numericality_of  :tb_seq_no, :less_than_or_equal_to=>9999,:allow_nil=>true 
 validates_associated :gl_category
 
  has_many :gl_details
  has_many :customer_receipts
  belongs_to :gl_category
  belongs_to :bank
#  scope :active, :conditions => { :trans_flag => 'A' }
  scope :account_type, lambda{|str1,str2|{ 
                             :conditions => ["account_type between '#{str1}' and '#{str1}'" ] }}
  scope :gl_accounts_only,  :conditions => { :acct_flag => 'A' }
  
  def self.fetch_gl_account_code_and_name(id)
    gl = self.find_by_id(id) if id
    return gl.code, gl.name if gl
  end
     
end
