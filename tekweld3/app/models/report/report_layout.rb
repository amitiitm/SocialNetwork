class Report::ReportLayout < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  include Report

  belongs_to :report, :class_name => 'Report::Report'
  has_many :report_layout_columns, :class_name => 'Report::ReportLayoutColumn' , :extend=>ExtendAssosiation
  has_many :report_layout_users, :class_name => 'Report::ReportLayoutUser' , :extend=>ExtendAssosiation
  validates :report_id,:presence => true
#  validates_uniqueness_of :name

  def add_line_details(column_doc)
    id = parse_xml(column_doc/'/id') if (column_doc/'/id').first
    line = reportlayoutcolumns(column_doc.name,id) || nil
    line.apply_attributes(column_doc) if line 
    line.lock_version=0
    line.save! if line.report_layout_id and line.report_layout_id != 0
  end
  
  def reportlayoutcolumns(name,id)
    id =''
    report_layout_columns.find_or_build(id) if name == 'report_layout_column' 
  end

  def add_user_line_details(doc)
    line = reportlayoutusers(doc)|| nil
    apply_user_line_attributes(line,doc) if line 
  end

  def reportlayoutusers(doc)
    report_layout_id = parse_xml(doc/'/id') if (doc/'/id').first
#    user_id = parse_xml(doc/'/user_id') if (doc/'/user_id').first
#    layout_obj = Report::ReportLayoutUser.find_by_report_layout_id_and_user_id(report_layout_id,user_id)
      sql = "DELETE from report_layout_users WHERE report_layout_id = #{report_layout_id.to_i}"
     ActiveRecord::Base.connection.execute(sql) 
    id= ''
    line = report_layout_users.find_or_build(id) 
    line
  end

  def apply_user_line_attributes(line,doc)
    line.user_id = parse_xml(doc/'/user_id').to_i if (doc/'/user_id').first
    line.report_layout_id = parse_xml(doc/'/report_layout_id').to_i if (doc/'/report_layout_id').first
    line.default_yn = parse_xml(doc/'/default_yn') if (doc/'/default_yn').first
  end
  
  def save_lines
    report_layout_columns.save_line 
    report_layout_users.save_line 
  end

  def add_line_errors_to_header
    add_line_item_errors(report_layout_columns)
    add_line_item_errors(report_layout_users)
  end

  def fill_default_header_values
  
  end
  
  def apply_header_fields_to_lines()
    self.report_layout_columns.each{ |line|
      if line.new_record?
        line.company_id = self.company_id
#        line.lock_version= self.lock_version
      end   
    }
  end
  
  
def remove_all_layoutcolumns(report_layout_id)
  sql = "DELETE from report_layout_columns WHERE report_layout_id = #{report_layout_id.to_i}"
  ActiveRecord::Base.connection.execute(sql) 
end


def remove_duplicate_layout(name,report_id)
  sql = "DELETE from report_layouts WHERE name = '#{name}' and layout_type='U' and report_id='#{report_id}' "
  ActiveRecord::Base.connection.execute(sql) 
end
end
