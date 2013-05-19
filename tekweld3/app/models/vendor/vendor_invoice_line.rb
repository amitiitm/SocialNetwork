class Vendor::VendorInvoiceLine < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  
  validates_presence_of :trans_bk,:trans_no, :trans_date, :serial_no,:message => "does not exist in Vendor Invoice Line" 
  validates_numericality_of  :gl_amt, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
  validates_length_of :description, :maximum=>40, :allow_nil=>true ,:message=>" cannot be more than 40 chars in Vendor Invoice Line"  
 
  belongs_to :vendor_invoice
  belongs_to :gl_account , :class_name => 'GeneralLedger::GlAccount'
end
