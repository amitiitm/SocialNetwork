class GeneralLedger::GlTransaction < ActiveRecord::Base
include UserStamp
include Dbobject
include Accounts::GlAccountLib

has_many :gl_transaction_lines, :dependent => :destroy, :extend=>ExtendAssosiation

#  belongs_to  :gl_account
attr_accessor  :max_serial_no, :docu_type
validates :trans_bk,:trans_no, :trans_date,:account_period_code,  :presence => true
validates_length_of :post_flag,  :maximum=>1,:allow_nil=>true , :message=>" cannot be more than 1 chars" 
validates_length_of :trans_type, :maximum=>4,:allow_nil=>true , :message=>" cannot be more than 4 chars"  

  
def generate_trans_no
  self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,self.docu_type,self.class,self.company_id)
end

def update_trans_no
  Setup::Sequence.upd_book_code(self.trans_bk,self.docu_type,self.trans_no,self.company_id)  
end  

def add_line_details(line_doc)
  id =  parse_xml(line_doc/'id') if (line_doc/'id').first
  line = gl_transaction_line(line_doc.name,id) || nil
  if line
    line.apply_attributes(line_doc) 
    line.fill_default_detail_values
    self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s if line.new_record?
  end
  gl = GeneralLedger::GlAccount.find(line.gl_account_id) if line.gl_account_id
  line.acct_flag = gl.acct_flag if gl
  line
 end
 
def gl_transaction_line(name,id)
 gl_transaction_lines.find_or_build(id) if name == 'gl_transaction_line'
end
 
def add_line_errors_to_header
 add_line_item_errors(gl_transaction_lines) if gl_transaction_lines
end
 

def fill_default_header_values
  self.post_flag ||= 'U' 
  self.trans_date ||= Time.now 
  self.trans_flag ||= 'A' 
end

def self.update_to_view_only(trans_bk,trans_no)
  gl_trans = self.find_by_trans_bk_and_trans_no(trans_bk,trans_no)
  gl_trans.update_attributes(:update_flag=>'V') if gl_trans
end
 
end


