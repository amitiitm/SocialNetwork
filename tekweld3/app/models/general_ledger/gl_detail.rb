class  GeneralLedger::GlDetail < ActiveRecord::Base
include UserStamp
include Dbobject
 
belongs_to :gl_account  

validates_presence_of :trans_bk,:trans_no, :trans_date,:account_period_code, :gl_account_id, :message => "does not exist for gl posting" 
validates_length_of :post_flag,  :maximum=>1,:allow_nil=>true , :message=>" cannot be more than 1 chars for gl posting" 
validates_length_of :trans_type, :maximum=>4,:allow_nil=>true , :message=>" cannot be more than 4 chars for gl posting"  
  
  def self.delete_posted_rows(trans_bk,trans_no)
    gl_details = self.find_all_by_trans_bk_and_trans_no(trans_bk,trans_no)
    gl_details.each{|li| li.destroy }
  end
   

end
