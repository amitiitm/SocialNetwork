class Main::MainSequence < ActiveRecord::Base
  establish_connection  'main_schema'
  include UserStamp
  include General
  
def self.update_document_lno(docu_typ)
#  upd_seq = true
   if seq = self.find_by_docu_typ_and_trans_flag(docu_typ,'A')     
      lno = seq.docu_lno.to_i + 1    
      seq.update_attributes(:docu_lno=>lno.to_s)
   end
   seq
end
end
