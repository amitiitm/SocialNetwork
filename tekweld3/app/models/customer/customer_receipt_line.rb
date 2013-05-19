class Customer::CustomerReceiptLine < ActiveRecord::Base
#require 'has_finder'
include UserStamp
include Dbobject
include GenericSelects
include General
include ClassMethods
include Accounts::RecevableLib
include Accounts::ReceiptLine


attr_accessor :period_close_flag, :old_balance_amt ,:description
validates :trans_bk,:trans_no, :trans_date,:serial_no,  :presence => true
validates_numericality_of  :original_amt, :apply_amt ,:balance_amt, :disctaken_amt, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
validates_length_of :voucher_no, :maximum=>40, :allow_nil=>true ,:message=>" cannot be more than 40 chars"  

belongs_to :customer
belongs_to :customer_receipt
belongs_to :gl_account , :class_name => 'GeneralLedger::GlAccount'
scope :applied, :conditions => { :apply_flag => 'Y'}

  def apply_receipt_line_attributes(cust_invoice)
    self.voucher_no = voucher_no_from_trans_no_bk(cust_invoice["trans_bk"],cust_invoice["trans_no"])
    self.serial_no = ''
    self.voucher_date = cust_invoice["trans_date"]
    self.apply_flag= 'N'
    self.gl_account_id = '' 
    self.apply_amt = 0
    self.apply_to=''
    self.ref_no = cust_invoice["trans_no"]
    self.trans_flag = cust_invoice["trans_flag"]
    self.trans_bk= cust_invoice["trans_bk"]
    self.trans_date = cust_invoice["trans_date"]
    self.due_date = cust_invoice["due_date"]
    self.lock_version = cust_invoice["lock_version"]    
    self.description = cust_invoice["description"]    
  end
  
  def self.build_invoice_receipt_line(cust_invoice)
    receipt_line = self.new
    receipt_line.apply_receipt_line_attributes(cust_invoice)
    receipt_line.original_amt = string_to_decimal(cust_invoice["inv_amt"])
    receipt_line.balance_amt = string_to_decimal(cust_invoice["balance_amt"])
    receipt_line.disctaken_amt = 0
    receipt_line    
  end

   def self.build_credit_receipt_line(cust_invoice)
    receipt_line = self.new
    receipt_line.apply_receipt_line_attributes(cust_invoice)
    receipt_line.original_amt = string_to_decimal(cust_invoice["received_amt"]) * -1
    receipt_line.balance_amt = string_to_decimal(cust_invoice["balance_amt"]) * -1
    receipt_line.disctaken_amt = 0  
    receipt_line 
  end
end
