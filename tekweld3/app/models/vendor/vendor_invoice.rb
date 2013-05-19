class Vendor::VendorInvoice < ActiveRecord::Base
include UserStamp
include Dbobject
include GenericSelects
include Accounts::PayableLib
include Accounts::Invoice

  attr_accessor  :max_serial_no,  :name, :city, :state, :zip, :phone1, :contact1, :docu_type
  validates_presence_of :trans_bk,:trans_no, :trans_date,:account_period_code,:vendor_id,  :message => "does not exist in vendor invoice" 
  validates_numericality_of  :inv_amt, :discount_amt, :paid_amt, :disctaken_amt, :balance_amt, :clear_amt,
                  :item_qty, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
  validates_numericality_of  :discount_per, :less_than_or_equal_to=>999.99,:allow_nil=>true 
  validates_length_of :description, :maximum=>40, :allow_nil=>true ,:message=>" cannot be more than 40 chars in vendor invoice"  
  validates_length_of :post_flag, :action_flag, :clear_flag,  :trans_type, :maximum=>1,:allow_nil=>true , :message=>" cannot be more than 1 chars in vendor invoice" 
  validates_length_of  :inv_type, :maximum=>4,:allow_nil=>true , :message=>" cannot be more than 4 chars in vendor invoice" 
 
  belongs_to :vendor
  has_many :vendor_invoice_lines , :conditions => { :trans_flag => 'A'},:dependent => :destroy,:extend=>ExtendAssosiation

#  def apply_header_fields_to_lines()
#    self.vendor_invoice_lines.each{ |od|
#      if od.new_record?
#        od.trans_no = self.trans_no
#        od.trans_bk = self.trans_bk
#        od.trans_date = self.trans_date
#        od.company_id = self.company_id
#      end   
#    }
#end
  
validate(:on => :create) do
  errors.add(:trans_no,"duplicate trans-no") if Vendor::VendorInvoice.find_by_trans_no_and_trans_bk_and_company_id(self.trans_no,self.trans_bk,self.company_id) 
end
  
#after_create do 
#  Setup::Sequence.upd_book_code(self.trans_bk,self.docu_type,self.trans_no)  if self.trans_bk == 'IN02' 
#end  
  
def add_line_details(line_doc)
  id =  parse_xml(line_doc/'/id') if (line_doc/'/id').first
  line = invoice_line(line_doc.name,id) || nil
  line.apply_attributes(line_doc) if line
end
 
 def invoice_line(name,id)
   vendor_invoice_lines.find_or_build(id) if name == 'vendor_invoice_line'
 end
 
 
 def save_lines
    vendor_invoice_lines.save_line 
 end
 
 def add_line_errors_to_header
   add_line_item_errors(vendor_invoice_lines)
 end
 
 def update_for_payments(action_flag,update_flag,voucher_applied_amt,voucher_discount_amt,new_balance,clear_flag)
  update_attributes(:action_flag => "#{action_flag}", :update_flag => "#{update_flag}",
                         :paid_amt => "#{voucher_applied_amt}" ,
                         :disctaken_amt => "#{voucher_discount_amt}" ,
                         :balance_amt =>" #{new_balance}",
                          :clear_flag => "#{clear_flag}")

  end
  
# def post_invoice()
#   self.save!
# end
 
 
end
