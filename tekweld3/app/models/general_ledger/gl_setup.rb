class GeneralLedger::GlSetup < ActiveRecord::Base
require 'has_finder'
include UserStamp
include Dbobject
include GenericSelects
include General
  validates_presence_of :ar_account_id, :ap_account_id, :message => "does not exist" 
  validates_presence_of :shipping_purchase_account_id, :shipping_sales_account_id, :message => "does not exist" 
  validates_presence_of :discount_purchase_account_id, :discount_sales_account_id, :message => "does not exist" 
  validates_presence_of :salestax_purchase_account_id, :salestax_sales_account_id, :message => "does not exist" 
  validates_presence_of :default_purchase_account_id, :default_sales_account_id, :message => "does not exist" 
 
  has_many :gl_setup_items, :class_name => 'GeneralLedger::GlSetupItem', :extend=>ExtendAssosiation
  belongs_to :ar_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "ar_account_id"
  belongs_to :ap_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "ap_account_id"
  belongs_to :shipping_purchase_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "shipping_purchase_account_id"
  belongs_to :shipping_sales_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "shipping_sales_account_id"
  belongs_to :discount_purchase_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "discount_purchase_account_id"
  belongs_to :discount_sales_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "discount_sales_account_id"
  belongs_to :salestax_purchase_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "salestax_purchase_account_id"
  belongs_to :salestax_sales_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "salestax_sales_account_id"
  belongs_to :default_purchase_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "default_purchase_account_id"
  belongs_to :default_sales_account,  :class_name => "GeneralLedger::GlAccount",
                        :foreign_key => "default_sales_account_id"

def add_line_details(line_doc)
  id =  parse_xml(line_doc/'id') if (line_doc/'id').first
  line = glsetupitems(line_doc.name,id) || nil
  line.apply_attributes(line_doc) if line
  line.fill_default_detail_values
 end
  
def glsetupitems(name,id)
  gl_setup_items.find_or_build(id) if name == 'gl_setup_item' 
end

def save_lines
  gl_setup_items.save_line 
end

def apply_header_fields_to_lines()
  self.gl_setup_items.each{ |line|
    if line.new_record?
      line.company_id = self.company_id
    end   
  }
end

def add_line_errors_to_header
  add_line_item_errors(gl_setup_items)
end

def fill_default_header_values
  self.trans_flag ||= 'A' 
end  
  
end