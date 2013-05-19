class Quotation::SalesQuotationLine < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include ClassMethods
  attr_accessor  :max_serial_no
  belongs_to :sales_quotation, :class_name => 'Quotation::SalesQuotation'
  belongs_to :company, :class_name => 'Setup::Company'
  belongs_to :catalog_item, :class_name => 'Item::CatalogItem'
  has_many :sales_quotation_line_charges, :class_name => 'Quotation::SalesQuotationLineCharge',:dependent => :destroy, :extend=>ExtendAssosiation
  has_many :sales_quotation_attributes_values, :class_name => 'Quotation::SalesQuotationAttributesValue',:dependent => :destroy, :extend=>ExtendAssosiation
  validates_uniqueness_of :serial_no, :scope=>[:trans_no, :trans_bk, :trans_date,:company_id]
  validates :catalog_item_id,:presence => true

  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = attributes_values(line_doc.name,id) || quotation_line_charges(line_doc.name,id) ||  nil
    line.apply_attributes(line_doc) if line
    if line.new_record?
      self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s
    end
    line.trans_flag = 'D' if self.trans_flag == 'D'
  end

  def quotation_line_charges(name,id)
    sales_quotation_line_charges.find_or_build(id) if name == 'sales_quotation_line_charge'
  end

  def attributes_values(name,id)
    sales_quotation_attributes_values.find_or_build(id) if name == 'sales_quotation_attributes_value'
  end
  
  def save_lines
    sales_quotation_line_charges.save_line
    sales_quotation_attributes_values.save_line
  end

  def add_line_errors_to_header
    add_line_item_errors(sales_quotation_line_charges) if sales_quotation_line_charges
    add_line_item_errors(sales_quotation_attributes_values) if sales_quotation_attributes_values
  end

  def fill_default_detail_values

  end
end
