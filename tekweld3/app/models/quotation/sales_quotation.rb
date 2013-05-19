class Quotation::SalesQuotation < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General

  attr_accessor  :max_serial_no
  has_many :sales_quotation_lines, :class_name => 'Quotation::SalesQuotationLine' , :extend=>ExtendAssosiation
  has_many :sales_quotation_attributes_values, :class_name => 'Quotation::SalesQuotationAttributesValue' , :extend=>ExtendAssosiation
  has_many :sales_quotation_shippings, :class_name => 'Quotation::SalesQuotationShipping' , :extend=>ExtendAssosiation
  has_many :sales_quotation_transaction_activities, :class_name => 'Quotation::SalesQuotationTransactionActivity' , :extend=>ExtendAssosiation
  belongs_to :company, :class_name => 'Setup::Company'
  belongs_to :customer, :class_name => 'Customer::Customer'
  validates_uniqueness_of :trans_no, :scope => [:trans_bk, :trans_no, :trans_date, :company_id]
 
  def generate_trans_no(docu_type)
    self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,docu_type,self.class,self.company_id)
  end

  after_create do
    Setup::Sequence.upd_book_code(self.trans_bk,'SAQIOD',self.trans_no,self.company_id)  if self.trans_bk == 'SQ01'
  end

  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = quotation_lines(line_doc.name,id) ||  quotation_shippings(line_doc.name,id) || nil
    line.apply_attributes(line_doc) if line
    if line.new_record?
      self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s
    end
    if line_doc.name == 'sales_quotation_line'
      line.build_lines(line_doc/:sales_quotation_line_charges/:sales_quotation_line_charge)
      line.build_lines(line_doc/:sales_quotation_attributes_values/:sales_quotation_attributes_value)
    end
  end

  def quotation_lines(name,id)
    sales_quotation_lines.find_or_build(id) if name == 'sales_quotation_line'
  end

  #  def quotation_attributes_values(name,id)
  #    sales_quotation_attributes_values.find_or_build(id) if name == 'sales_quotation_attributes_value'
  #  end

  def quotation_shippings(name,id)
    sales_quotation_shippings.find_or_build(id) if name == 'sales_quotation_shipping'
  end

  def save_lines
    sales_quotation_lines.save_line
    #    sales_quotation_attributes_values.save_line
    sales_quotation_shippings.save_line
  end

  def add_line_errors_to_header
    add_line_item_errors(sales_quotation_lines) if sales_quotation_lines
    #    add_line_item_errors(sales_quotation_attributes_values) if sales_quotation_attributes_values
    add_line_item_errors(sales_quotation_shippings) if sales_quotation_shippings
  end

  def fill_default_header_values
    self.trans_flag ||= 'A'
    self.post_flag ||= 'U'
    self.trans_flag ||= 'A'
    self.trans_bk = 'SQ01'
    self.item_qty ||= 0.00
    self.item_amt ||= 0.00
    self.discount_amt ||= 0.00
    self.net_amt ||= 0.00
    self.tax_amt ||= 0.00
    self.discount_per ||= 0.00
  end

  def apply_header_fields_to_lines()
    self.sales_quotation_lines.each{ |line|
      line.trans_bk = self.trans_bk
      line.trans_no = self.trans_no
      line.trans_date = self.trans_date
      line.company_id = self.company_id
      line.account_period_code = self.account_period_code
    }
  end

  def create_sales_quotation_transaction_activity(sales_quotation_stage_code)
    activity = self.sales_quotation_transaction_activities.build
    activity.company_id = self.company_id
    activity.trans_no = self.trans_no
    activity.trans_bk = self.trans_bk
    activity.sales_quotation_stage_code = sales_quotation_stage_code
    activity.trans_date = self.trans_date
    activity.updated_by = self.updated_by || self.created_by
    activity.created_by = self.created_by
    activity.created_at = self.created_at
    activity.updated_at = self.updated_at
    activity.update_flag = self.update_flag
    activity.trans_flag = self.trans_flag
    activity.activity_date = Time.now
    activity.remarks = self.remarks
    activity.sequence_no = 100
    activity.user_id = self.updated_by || self.created_by
    return activity
  end

end
