class Purchase::PurchasePackingSlip < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include Purchase::PurchasePosting
  
  attr_accessor  :max_serial_no
  
  has_many :purchase_packing_slip_lines, :class_name => 'Purchase::PurchasePackingSlipLine' , :extend=>ExtendAssosiation
  belongs_to :company, :class_name => 'Setup::Company'
  belongs_to :vendor, :class_name => 'Vendor::Vendor'
  #  belongs_to :company_store, :class_name => 'Setup::CompanyStore'

  validates_uniqueness_of :trans_no, :scope => [:trans_bk, :trans_no, :trans_date, :company_id]
  validates_presence_of :vendor, :message=>'not exist'

  validates_presence_of :trans_bk, :trans_no, :trans_date, :vendor_id, :account_period_code, :message=>'Can not be blank'
  validates_numericality_of :item_qty,:item_amt, :tax_amt, :discount_amt, :net_amt, :allow_nil=>false, :less_than_or_equal_to=>999999999.99, :default=>0
  validates_numericality_of :discount_per,:allow_nil=>false, :less_than_or_equal_to=>9999.99, :default=>0.00
  
  def generate_trans_no(docu_type)
    self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,docu_type,self.class,self.company_id)
  end

  after_create do 
    Setup::Sequence.upd_book_code(self.trans_bk,'PAOIPS',self.trans_no,self.company_id)  if self.trans_bk == 'PL01' 
  end  

  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = packinglines(line_doc.name,id) || nil
    line.apply_attributes(line_doc) if line
    line.fill_default_detail_values
    line.item_qty = 0 if line.trans_flag == 'D'
    line.item_price = 0 if line.trans_flag == 'D' 
    line.net_amt = 0 if line.trans_flag == 'D' 
    self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s if line.new_record?
    line.add_line_details(line_doc)
  end
  
  def packinglines(name,id)
    purchase_packing_slip_lines.find_or_build(id) if name == 'purchase_packing_slip_line' 
  end

  def save_lines
    purchase_packing_slip_lines.save_line 
  end

  def add_line_errors_to_header
    add_line_item_errors(purchase_packing_slip_lines)
  end

  def fill_default_header_values
    self.post_flag ||= 'U' 
    self.trans_flag ||= 'A' 
    self.trans_bk = 'PL01'
    self.item_qty ||= 0.00  
    self.item_amt ||= 0.00 
    self.discount_amt ||= 0.00 
    self.net_amt ||= 0.00 
    self.tax_amt ||= 0.00 
    self.discount_per ||= 0.00 
  end
  
  def apply_header_fields_to_lines()
    self.purchase_packing_slip_lines.each{ |line|
      line.trans_bk = self.trans_bk
      line.trans_no = self.trans_no
      line.trans_date = self.trans_date
      line.company_id = self.company_id
      line.account_period_code = self.account_period_code
      line.ref_type = self.ref_type
      line.apply_header_fields_to_lines
    }
  end

  def apply_line_fields_to_header() 
    total_qty = 0
    self.purchase_packing_slip_lines.each{ |line|
      line.item_qty = 0 if !line.item_qty
      total_qty += line.item_qty
    }
    self.item_qty = total_qty
  end

  def self.update_to_view_only(trans_bk,trans_no,company_id)
    order = self.find_by_trans_bk_and_trans_no_and_company_id(trans_bk,trans_no,company_id)
    order.update_attributes(:update_flag=>'V') if order
  end
  
end