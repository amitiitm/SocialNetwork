class Crm::CrmLead < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include ClassMethods
  include GenericSelects
  
  attr_accessor  :max_serial_no
  #  set_table_name :crm_leads

  has_many :lead_notess,  :class_name => 'Crm::LeadNote', :extend=>ExtendAssosiation 
  validates_uniqueness_of :lead_number, :message => "should not be duplicate"
  
  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = lead_notes(line_doc.name,id) || nil
    line.apply_attributes(line_doc) if line
    self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s if line.new_record?
  end
 
  def lead_notes(name,id)
    lead_notess.find_or_build(id) if name == 'lead_note'
  end

  def save_lines
    lead_notess.save_line 
  end

  def add_line_errors_to_header
    add_line_item_errors(lead_notess) 
  end

end