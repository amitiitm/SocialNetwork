class Customer::CustomerReceipt < ActiveRecord::Base
include UserStamp
include Dbobject
include GenericSelects
include Accounts::Receipts
include Accounts::BankPosting
include Accounts::RecevableLib

attr_accessor  :max_serial_no,   :name, :city, :state, :zip, :phone1, :contact1, :docu_type
validates :trans_bk,:trans_no, :trans_date,:account_period_code,:customer_id,  :presence => true
validates_numericality_of  :received_amt, :applied_amt ,:balance_amt, :item_qty, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
validates_length_of :description, :maximum=>40, :allow_nil=>true ,:message=>" cannot be more than 40 chars"  

belongs_to :customer
belongs_to :bank , :class_name => 'GeneralLedger::Bank'
belongs_to :gl_account, :class_name => 'GeneralLedger::GlAccount', :foreign_key => "bank_id"
has_many :detail_lines ,:class_name =>'CustomerReceiptLine',:foreign_key => 'customer_receipt_id',:conditions => { :trans_flag => 'A'},:dependent => :destroy, :extend=>ExtendAssosiation 
  
before_validation do
#  apply_new_receipt_line_fields
  fill_default_header_values
  fill_default_detail_values
end

validate(:on => :create) do
  errors.add(:trans_no,"duplicate trans-no") if Customer::CustomerReceipt.find_by_trans_no_and_company_id_and_trans_bk(self.trans_no,self.company_id,self.trans_bk)
  end
 
def add_line_details(line_doc)
  id =  parse_xml(line_doc/'id') if (line_doc/'id').first
  apply_flag = parse_xml(line_doc/'apply_flag') if (line_doc/'apply_flag').first
  apply_amt = parse_xml(line_doc/'apply_amt').to_d if (line_doc/'apply_amt').first
  disctaken_amt = parse_xml(line_doc/'disctaken_amt').to_d if (line_doc/'disctaken_amt').first
  if is_blank_id?(id)
    line = detail_lines.build if (apply_amt +  disctaken_amt) != 0 
  else  
    line = detail_lines.to_ary.find { |li| li.id == id.to_i } 
  end
  if line
    line.apply_attributes(line_doc) 
    self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s if line.new_record?
    line.calculate_receipt_line_amounts   
  end
 end

def check_amt
  nulltozero(self.received_amt)
end 

def receipt_lines(name,id)
   detail_lines.find_or_build(id) if name == 'customer_receipt_line'
end
 
 def save_lines
   detail_lines.save_line 
 end
 
 def delete_unapplied_lines
  detail_lines.delete_line
 end
 
 def add_line_errors_to_header
   add_line_item_errors(detail_lines)
 end
 

def update_for_receipts(action_flag,update_flag,applied_amt,new_balance)
    update_attributes(:action_flag => "#{action_flag}", 
                      :update_flag => "#{update_flag}",
                      :applied_amt => "#{applied_amt}" ,
                      :balance_amt =>" #{new_balance}")

  end
  
def post_receipt
  self.save!
end
end