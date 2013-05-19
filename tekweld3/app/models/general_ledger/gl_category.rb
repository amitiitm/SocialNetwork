class  GeneralLedger::GlCategory < ActiveRecord::Base
require 'has_finder'
include UserStamp
include Dbobject
include GenericSelects

 validates_presence_of :code,  :message => "does not exist" 
 validates_uniqueness_of :code, :message=>" is duplicate!!!"
 validates_length_of :account_type, :maximum=>2, :allow_nil=>true ,:message=>" cannot be more than 2 chars"  
 
  has_many :gl_accounts
  has_many :banks
#  scope :active, :conditions => { :trans_flag => 'A' }
  scope :account_type, lambda{|str5,str6|{ 
                             :conditions => ["account_type between ''#{str5[0,2]} and '#{str6[0,2]}'" ] }}
end
