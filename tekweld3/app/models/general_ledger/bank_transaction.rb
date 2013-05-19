class GeneralLedger::BankTransaction < ActiveRecord::Base  
  include UserStamp
  include Dbobject
  include GenericSelects
  include Accounts::BankTransactionLib
 
  attr_accessor :max_serial_no,:salesperson_code,:parent_id,:parent_code,:glaccount_id, :bank1_name, :bank2_name,:bank_account_flag, :docu_type
  belongs_to :gl_account, :foreign_key => "bank_id" 
  has_many :bank_transaction_lines , :dependent => :destroy, :extend=>ExtendAssosiation

  scope :contra_entry, 
    :conditions => "serial_no = '101'"

  validates :trans_bk,:trans_no, :trans_date,:account_period_code,  :presence => true
  validates_length_of :post_flag, :clear_flag, :action_flag,  :maximum=>1,:allow_nil=>true , :message=>" cannot be more than 1 chars" 
  validates_length_of :trans_type,:maximum=>4,:allow_nil=>true , :message=>" cannot be more than 4 chars"  
  validates_length_of :check_no, :maximum=>15,:allow_nil=>true , :message=>" cannot be more than 15 chars" 
  validates_numericality_of  :debit_amt, :credit_amt , :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
  #validates_uniqueness_of :check_no,:allow_nil=>true, :if => :trans_type == 'PAYM'

  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = bank_transaction_lines.find_or_build(id) if line_doc.name == 'bank_transaction_line'
    if line
      line.apply_attributes(line_doc) 
      line.fill_default_detail_values
      self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s if line.new_record?
    end
    line
  end

  def fill_default_header_values  
    self.account_flag = 'B' if bank_transfer?(self.trans_type)
    self.trans_date ||= Time.now 
    self.check_date ||= Time.now
    self.post_flag ||= 'U'
    self.clear_flag ||= 'N'
    self.action_flag ||= 'O'
    self.debit_amt ||= 0
    self.credit_amt ||= 0
  end


  def add_line_errors_to_header
    add_line_item_errors(bank_transaction_lines) if bank_transaction_lines
  end
 
end
