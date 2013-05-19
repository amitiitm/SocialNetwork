class Inventory::InventoryTransaction < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods

  attr_accessor  :max_serial_no
  
  has_many :inventory_transaction_lines, :class_name => 'Inventory::InventoryTransactionLine' , :extend=>ExtendAssosiation
  belongs_to :company, :class_name => 'Setup::Company'

  validates_uniqueness_of :trans_no, :scope => [:trans_bk, :trans_no, :trans_date,:company_id]

  validates :trans_bk, :trans_no, :trans_date, :account_period_code, :presence => true
  validates_size_of :inventory_transaction_lines, :minimum => 1, :message => "--At least one item is required to save Inventory transaction" 

def generate_trans_no(docu_type)
  self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,docu_type,self.class,self.company_id)
end

after_create do 
  Setup::Sequence.upd_book_code(self.trans_bk,'INVNIS',self.trans_no,self.company_id)  if self.trans_bk == 'IS01' 
  Setup::Sequence.upd_book_code(self.trans_bk,'INVNRE',self.trans_no,self.company_id)  if self.trans_bk == 'RE01' 
  Setup::Sequence.upd_book_code(self.trans_bk,'INVNTR',self.trans_no,self.company_id)  if self.trans_bk == 'TR01' 
  Setup::Sequence.upd_book_code(self.trans_bk,'INVNTR',self.trans_no,self.company_id)  if self.trans_bk == 'TR05' 
end  

def add_line_details(line_doc)
  id =  parse_xml(line_doc/'id') if (line_doc/'id').first
  line = inventorytransactionlines(line_doc.name,id) || nil
  line.apply_attributes(line_doc) if line
  line.fill_default_detail_values
  self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s if line.new_record?
end
  
def inventorytransactionlines(name,id)
  inventory_transaction_lines.find_or_build(id) if name == 'inventory_transaction_line' or name == 'inventory_transaction_issue_line' or name == 'inventory_transaction_receive_line'
end

def add_receive_line_details(id)
  inventory_transaction_lines.find_or_build(id)
end

def save_lines
  inventory_transaction_lines.save_line 
end

def add_line_errors_to_header
  add_line_item_errors(inventory_transaction_lines)
end

def fill_default_header_values
#  self.post_flag ||= 'U' 
  self.trans_flag ||= 'A' 
end
  
def apply_header_fields_to_lines()
#  self.trans_date=dateformat(self.trans_date,'dmy')
  self.inventory_transaction_lines.each{ |line|
#    if line.new_record?
      line.trans_bk = self.trans_bk
      line.trans_no = self.trans_no
      line.trans_date = self.trans_date
      line.company_id = self.company_id
      line.account_period_code = self.account_period_code
#    end   
  }
 
end

def apply_line_fields_to_header() 
#  total_qty = 0
#  self.inventory_transaction_lines.each{ |line|
#      line.item_qty = 0 if !line.item_qty
#      #total_qty = total_qty + nulltozero(line.item_qty)
#      total_qty += line.item_qty
#  }
#  self.item_qty = total_qty
end

def self.update_to_view_only(trans_bk,trans_no,company_id)
  order = self.find_by_trans_bk_and_trans_no_and_company_id(trans_bk,trans_no,company_id)
  order.update_attributes(:update_flag=>'V') if order
end

end
