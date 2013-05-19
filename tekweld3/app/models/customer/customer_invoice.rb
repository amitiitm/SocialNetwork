class Customer::CustomerInvoice < ActiveRecord::Base
include UserStamp
include Dbobject
include GenericSelects
include Accounts::RecevableLib
include Accounts::Invoice

  attr_accessor  :max_serial_no,  :name, :city, :state, :zip, :phone1, :contact1, :docu_type
  validates_presence_of :trans_bk,:trans_no, :trans_date,:account_period_code,:customer_id,  :message => "does not exist" 
  validates_numericality_of  :inv_amt, :discount_amt, :paid_amt, :disctaken_amt, :balance_amt, :clear_amt,
                  :item_qty, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
  validates_numericality_of  :discount_per, :less_than_or_equal_to=>999.99,:allow_nil=>true 
  validates_length_of :description, :maximum=>40, :allow_nil=>true ,:message=>" cannot be more than 40 chars"  
  validates_length_of :post_flag, :action_flag, :clear_flag,  :trans_type, :maximum=>1,:allow_nil=>true , :message=>" cannot be more than 1 chars" 
  validates_length_of  :inv_type, :maximum=>4,:allow_nil=>true , :message=>" cannot be more than 4 chars" 
 
  belongs_to :customer
  has_many :customer_invoice_lines ,:conditions => { :trans_flag => 'A'}, :dependent => :destroy,:extend=>ExtendAssosiation
  
validate(:on => :create) do
  errors.add(:trans_no,"duplicate trans-no") if Customer::CustomerInvoice.find_by_trans_no_and_company_id_and_trans_bk(self.trans_no,self.company_id,self.trans_bk) 
end
   
def add_line_details(line_doc)
  id =  parse_xml(line_doc/'id') if (line_doc/'id').first
  line = invoice_line(line_doc.name,id) || nil
  line.apply_attributes(line_doc) if line
  line.fill_gl_code_name
end
 
def invoice_line(name,id)
 customer_invoice_lines.find_or_build(id) if name == 'customer_invoice_line'
end
 
 
def save_lines
  customer_invoice_lines.save_line 
end

def add_line_errors_to_header
 add_line_item_errors(customer_invoice_lines)
end
 
def update_for_receipts(action_flag,update_flag,voucher_applied_amt,voucher_discount_amt,new_balance)
update_attributes(:action_flag => "#{action_flag}", :update_flag => "#{update_flag}",
                       :paid_amt => "#{voucher_applied_amt}" ,
                       :disctaken_amt => "#{voucher_discount_amt}" ,
                       :balance_amt =>" #{new_balance}")

end
  
def post_invoice()
 self.save!
end

 

end
