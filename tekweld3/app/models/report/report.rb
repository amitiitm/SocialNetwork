class Report::Report < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General

  has_many :report_columns, :class_name => 'Report::ReportColumn' , :extend=>ExtendAssosiation
  has_many :report_layouts, :class_name => 'Report::ReportLayout' , :extend=>ExtendAssosiation


  validates_uniqueness_of :code ,  :message=>'can not be duplicate'
  validates_uniqueness_of :document_id,  :message=>' no can not be duplicate'
   
  def add_line_details(column_doc)
    id =  parse_xml(column_doc/'id') if (column_doc/'id').first
    line = reportcolumns(column_doc.name,id) || nil
    line.apply_attributes(column_doc) if line
    line.fill_default_detail_values
  end
  
  def reportcolumns(name,id)
    report_columns.find_or_build(id) if name == 'report_column' 
  end

  def save_lines
    report_columns.save_line 
  end

  def add_line_errors_to_header
    add_line_item_errors(report_columns)
  end

  def fill_default_header_values
   
  end
  
  def apply_header_fields_to_lines()
    self.report_columns.each{ |line|
      if line.new_record?
        line.company_id = self.company_id
      end   
    }
  end
end
