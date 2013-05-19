class Purchase::PurchaseIndent < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  
  attr_accessor  :max_serial_no
  
  has_many :purchase_indent_lines, :class_name => 'Purchase::PurchaseIndentLine' , :extend=>ExtendAssosiation
  belongs_to :company, :class_name => 'Setup::Company'
  
  validates_presence_of :trans_bk, :trans_no, :trans_date, :account_period_code, :message=>'Can not be blank'
  validates_numericality_of :item_qty, :clear_qty,  :allow_nil=>false, :less_than_or_equal_to=>999999999.99, :default=>0
  
  def generate_trans_no(docu_type)
  self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,docu_type,self.class,self.company_id)
end

after_create do 
  Setup::Sequence.upd_book_code(self.trans_bk,'PDOIPR',self.trans_no,self.company_id)  if self.trans_bk == 'PD01' 
end  

def add_line_details(line_doc)
  id =  parse_xml(line_doc/'id') if (line_doc/'id').first
  line = orderlines(line_doc.name,id) || nil
  line.apply_attributes(line_doc) if line
  line.fill_default_detail_values
  line.item_qty = 0 if line.trans_flag == 'D' 
  self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s if line.new_record?
end
  
def orderlines(name,id)
  purchase_indent_lines.find_or_build(id) if name == 'purchase_indent_line' 
end

def save_lines
  purchase_indent_lines.save_line 
end

def add_line_errors_to_header
  add_line_item_errors(purchase_indent_lines)
end

def fill_default_header_values
  self.post_flag ||= 'U' 
  self.trans_flag ||= 'A' 
  self.trans_bk = 'PD01'
end
  
def apply_header_fields_to_lines()
  self.purchase_indent_lines.each{ |line|
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
  total_qty = 0
  self.purchase_indent_lines.each{ |line|
      line.item_qty = 0 if !line.item_qty
      #total_qty = total_qty + nulltozero(line.item_qty)
      total_qty += line.item_qty
  }
  self.item_qty = total_qty
end

def self.update_to_view_only(trans_bk,trans_no,company_id)
  purchase_indent = self.find_by_trans_bk_and_trans_no_and_company_id(trans_bk,trans_no,company_id)
  purchase_indent.update_attributes(:update_flag=>'V') if purchase_indent
end
  
end
