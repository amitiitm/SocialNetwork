class Vendor::VendorPaymentLine < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  include General
  include ClassMethods
  include Accounts::PayableLib
  include Accounts::ReceiptLine

  attr_accessor :period_close_flag, :old_balance_amt,:description
  validates_presence_of :trans_bk,:trans_no, :trans_date,:serial_no,  :message => "does not exist" 
  validates_numericality_of  :original_amt, :apply_amt ,:balance_amt, :disctaken_amt, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
  validates_length_of :voucher_no, :maximum=>40, :allow_nil=>true ,:message=>" cannot be more than 40 chars"  

  belongs_to :vendor
  belongs_to :vendor_payment
  belongs_to :gl_account , :class_name => 'GeneralLedger::GlAccount'
  scope :applied, :conditions => { :apply_flag => 'Y'}

  def apply_payment_line_attributes(vend_invoice)
    self.voucher_no = voucher_no_from_trans_no_bk(vend_invoice["trans_bk"],vend_invoice["trans_no"])
    self.serial_no = ''
    self.voucher_date = vend_invoice["trans_date"]
    self.apply_flag= 'N'
    self.gl_account_id = '' 
    self.apply_amt = 0
    self.apply_to=''
    self.ref_no = vend_invoice["inv_no"]
    self.trans_flag = vend_invoice["trans_flag"]
    self.trans_bk= vend_invoice["trans_bk"]
    self.trans_date = vend_invoice["trans_date"]
    self.due_date = vend_invoice["due_date"]
    self.lock_version = vend_invoice["lock_version"]    
    self.description = vend_invoice["description"]    
  end
  
  def self.build_invoice_payment_line(vend_invoice)
    payment_line = self.new
    payment_line.apply_payment_line_attributes(vend_invoice)
    payment_line.original_amt = string_to_decimal(vend_invoice["inv_amt"])
    payment_line.balance_amt = string_to_decimal(vend_invoice["balance_amt"])
    payment_line.disctaken_amt = 0
    payment_line    
  end

  def self.build_credit_payment_line(vend_invoice)
    payment_line = self.new
    payment_line.apply_payment_line_attributes(vend_invoice)
    payment_line.original_amt = string_to_decimal(vend_invoice["paid_amt"]) * -1
    payment_line.balance_amt = string_to_decimal(vend_invoice["balance_amt"]) * -1
    payment_line.disctaken_amt = 0  
    payment_line 
  end
end
