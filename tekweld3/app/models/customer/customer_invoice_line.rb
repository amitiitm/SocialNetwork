class Customer::CustomerInvoiceLine < ActiveRecord::Base
include UserStamp
include Dbobject
include GenericSelects

attr_accessor :gl_code, :gl_name
validates_presence_of :trans_bk,:trans_no, :trans_date, :serial_no,:message => "does not exist" 
validates_numericality_of  :gl_amt, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
validates_length_of :description, :maximum=>40, :allow_nil=>true ,:message=>" cannot be more than 40 chars"  

belongs_to :customer_invoice
belongs_to :gl_account , :class_name => 'GeneralLedger::GlAccount'

def fill_gl_code_name
  gl = self.gl_account
  self.gl_code = gl.code if gl
  self.gl_name = gl.name if gl
end
  
end
