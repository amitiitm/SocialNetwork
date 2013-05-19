class Setup::Sequence < ActiveRecord::Base
  include Dbobject
  include UserStamp
  include General
   belongs_to :company, :class_name => 'Setup::Company'
  def self.generate_docu_no(book_code,docu_typ,model,company_id)
  begin
    if lno = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and docu_typ = ? and company_id =? and trans_flag = 'A'",book_code, docu_typ,company_id])     
      lno =lno.to_i + 1
    end 
#    lno = lno.to_s
    if model.find_by_trans_no_and_trans_bk_and_company_id(lno.to_s,book_code,company_id) 
      if model_lno = model.maximum(:trans_no, :conditions=>["trans_bk = ? and company_id=?",book_code,company_id])
        lno = model_lno.to_i + 1
      end  
    end
    rescue ActiveRecord::RecordNotFound  
      lno = nil
  end      
    lno.to_s
  end



def self.upd_book_code(book_code,docu_typ,trans_no,company_id)
  begin
   seq = Setup::Sequence.find_by_book_cd_and_docu_typ_and_company_id_and_trans_flag(book_code, docu_typ,company_id, 'A')  
   book_lno = seq ? seq.book_lno : 0
   lno = (book_lno.to_i >=  trans_no.to_i) ? book_lno.to_i + 1  : trans_no
#      lno = (seq.book_lno).to_i + 1    
#      lno = lno.to_s
   seq.update_attributes(:book_lno=>lno.to_s)  if seq
#   end
   rescue ActiveRecord::RecordNotFound  
      lno = nil
  end  
  
end

def fill_default_detail_values
end
 
end
