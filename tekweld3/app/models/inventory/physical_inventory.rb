class Inventory::PhysicalInventory < ActiveRecord::Base
include UserStamp
include Dbobject
include General
include ClassMethods

  attr_accessor  :max_serial_no
  has_many :physical_inventory_lines, :class_name => 'Inventory::PhysicalInventoryLine' , :extend=>ExtendAssosiation
  validates_presence_of :trans_bk, :trans_no,:message=>'Can not be blank'
  validates_uniqueness_of :trans_no
  
  def generate_trans_no(docu_type)
    self.trans_no = Setup::Sequence.generate_docu_no(self.trans_bk,docu_type,self.class,self.company_id)
  end

  after_create do 
    Setup::Sequence.upd_book_code(self.trans_bk,'INVNPH',self.trans_no,self.company_id)  if self.trans_bk == 'PH02' 
  end  

  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = invnlines(line_doc.name,id) || nil
    line.apply_attributes(line_doc) if line
#    line.fill_default_detail_values
    self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s if line.new_record?
  end
  
  def invnlines(name,id)
    physical_inventory_lines.find_or_build(id) if name == 'physical_inventory_line' 
  end

  def save_lines
    physical_inventory_lines.save_line 
  end

  def add_line_errors_to_header
    add_line_item_errors(physical_inventory_lines)
  end
  
  def fill_default_header_values 
    self.trans_flag ||= 'A' 
    self.trans_bk = 'PH02'
  end
  
  def apply_header_fields_to_lines()
    self.physical_inventory_lines.each{ |line|
#      if line.new_record?
        line.trans_bk = self.trans_bk
        line.trans_no = self.trans_no
        line.trans_date = self.trans_date
        line.company_id = self.company_id
#      end   
    }
  end
end
