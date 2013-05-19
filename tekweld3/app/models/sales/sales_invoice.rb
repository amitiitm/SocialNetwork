class Sales::SalesInvoice < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include GenericSelects
  include Sales::SalesPosting
  attr_accessor  :max_serial_no
  
  has_many :sales_invoice_lines, :class_name => 'Sales::SalesInvoiceLine' , :extend=>ExtendAssosiation
  belongs_to :company, :class_name => 'Setup::Company'
  belongs_to :customer, :class_name => 'Customer::Customer'
  #  belongs_to :company_store, :class_name => 'Setup::CompanyStore'

  validates_uniqueness_of :trans_no, :scope => [:trans_bk, :trans_no, :trans_date,:company_id]
  validates :trans_bk, :trans_no, :trans_date, :customer_id, :account_period_code,:customer, :presence => true

  #  validates_numericality_of :item_qty, :discount_per,:item_amt, :tax_amt, :discount_amt, :net_amt, :allow_nil=>false, :less_than_or_equal_to=>999999999.99, :default=>0
  
  after_create do 
    Setup::Sequence.upd_book_code(self.trans_bk,'SAOIIN',self.trans_no,self.company_id)  if self.trans_bk == 'SI01' 
  end  


  def generate_trans_no(docu_type)
    self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,docu_type,self.class,self.company_id)
  end

  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = invoicelines(line_doc.name,id) || nil
    line.apply_attributes(line_doc) if line
    line.fill_default_detail_values
    line.item_qty = 0 if line.trans_flag == 'D' 
    line.item_price = 0 if line.trans_flag == 'D' 
    line.net_amt = 0 if line.trans_flag == 'D' 
    self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s if line.new_record?
  end
  
  def invoicelines(name,id)
    sales_invoice_lines.find_or_build(id) if name == 'sales_invoice_line' 
  end

  def save_lines
    sales_invoice_lines.save_line 
  end

  def add_line_errors_to_header
    add_line_item_errors(sales_invoice_lines)
  end

  def fill_default_header_values
    self.post_flag ||= 'U' 
    self.trans_flag ||= 'A' 
    self.trans_bk = 'SI01' 
  end
  
  def apply_header_fields_to_lines()
    self.sales_invoice_lines.each{ |line|
      line.trans_bk = self.trans_bk
      line.trans_no = self.trans_no
      line.trans_date = self.trans_date
      line.company_id = self.company_id
      line.account_period_code = self.account_period_code
      line.ref_type = self.ref_type
    }
  end

  def apply_line_fields_to_header() 
    total_qty = 0
    total_amt = 0
    total_net_amt = 0
    self.sales_invoice_lines.each{ |line|
      line.item_qty = 0 if !line.item_qty
      line.item_amt = 0 if !line.item_amt
      line.net_amt = 0 if !line.net_amt
      total_qty += line.item_qty if line.item_type == 'I'
      total_amt += line.item_amt 
      total_net_amt += line.net_amt
    }
    self.item_qty = total_qty
    self.item_amt = total_amt
    self.net_amt = total_net_amt + self.ship_amt
  end

  def self.update_to_view_only(trans_bk,trans_no,company_id)
    invoice = self.find_by_trans_bk_and_trans_no_and_company_id(trans_bk,trans_no,company_id)
    invoice.update_attributes(:update_flag=>'V') if invoice
  end

end
