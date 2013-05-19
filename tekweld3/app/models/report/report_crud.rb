class Report::ReportCrud < Crud
  include General
 
  def self.list_reports(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
#    Report::Report.find(:all,
#                  
#      :conditions => ["(code between ? and ? AND (0 =? or code in (?))) AND
#                                       (name between ? and ? AND (0 =? or name in (?)))   AND
#                                           reports.trans_flag='A'  ",
#      
#        criteria.str1, criteria.str2 ,criteria.multiselect1.length,criteria.multiselect1 ,
#        criteria.str3, criteria.str4 ,criteria.multiselect2.length,criteria.multiselect2],
#      :select=>'reports.*',
#      :order => "document_id"
#    )
   Report::Report.find(:all,
                  
      :conditions => ["(code between ? and ? AND (0 =? or code in (?))) AND
                                       (name between ? and ? AND (0 =? or name in (?)))",
      
        criteria.str1, criteria.str2 ,criteria.multiselect1.length,criteria.multiselect1 ,
        criteria.str3, criteria.str4 ,criteria.multiselect2.length,criteria.multiselect2],
      :select=>'reports.*',
      :order => "document_id"
    )
  end

  def self.show_report(report_id)
    Report::Report.find_all_by_id(report_id)
  end

  def self.create_reports(doc)
    reports = [] 
    report_layouts = []
    (doc/:reports/:report).each{|report_doc|
      report, report_layouts = create_report(report_doc)
      reports <<  report if report
    }
    return  reports , report_layouts
  end

  def self.create_report(doc)
    report = add_or_modify_report(doc) 
    report.apply_header_fields_to_lines  
    return  if !report
    save_proc = Proc.new{
      if report.new_record?
        report.save!  
      else
        report.save! 
        report.report_columns.save_line
      end
    }
    report_layout = create_report_layouts(doc)
    report.save_transaction(&save_proc)
    return report , report_layout
  end

  def self.add_or_modify_report(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    report = Report::Report.find_or_create(id) 
    return if !report
    report.apply_attributes(doc) 
    report.fill_default_header_values() if report.new_record? 
    report.build_lines(doc/:report_columns/:report_column)  
    return report 
  end

  def self.list_report_layouts(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Report::ReportLayout.find(:all,
                             :conditions => ["layout_type = ? AND name = ?" ,
                                              criteria.str1[0,1],criteria.str2],
                             :order => "id"
                              )
  end
  
  def self.show_report_layout(report_layout_id)
    Report::ReportLayout.find_all_by_id(report_layout_id)
  end

  def self.create_report_layouts(doc)
    report_layouts = [] 
    (doc/:report_layouts/:report_layout).each{|report_doc|
      report_layout = create_report_layout(report_doc)
      report_layouts <<  report_layout if report_layout
    }
   
    report_layouts
  end

  def self.create_report_layout(doc)
    report_layout_id = parse_xml(doc/'id') if (doc/'id').first
    report_layout_obj = Report::ReportLayout.new
    report_layout_obj.remove_all_layoutcolumns(report_layout_id)
#    Report::ReportLayoutColumn.delete_all(['report_layout_id = ? ',report_layout_id])
    report_layout = add_or_modify_report_layout(doc) 
    report_layout.apply_header_fields_to_lines  
    return  if !report_layout
    save_proc = Proc.new{
      if report_layout.new_record?
         report_layout.save!  
      else
        report_layout.save! 
        report_layout.report_layout_columns.save_line
        report_layout.report_layout_users.save_line
      end
    }
    report_layout.save_transaction(&save_proc)
    user_id = parse_xml(doc/'user_id') if (doc/'user_id').first  
    default_yn =  parse_xml(doc/'default_yn') if (doc/'default_yn').first
    document_id =  parse_xml(doc/'document_id') if (doc/'document_id').first  
      if default_yn == 'Y' 
        id = report_layout[:id]
        id ||= 0
        layout_users = Report::ReportLayoutUser.find(:all,
                                                :conditions => ["user_id = ?  and report_layout_id <> ? and 
                                                                 report_layout_id in( select id from report_layouts 
                                                                 where report_id=(select id from reports where document_id=?))" ,user_id,id,document_id]
      )
    end
    save_proc = Proc.new{
#      if report_layout.new_record?
#        report_layout.save!
#      else
#        report_layout.save! 
#      end
      layout_users.each{|row|
        row[:default_yn] = 'N'
        row.save!
      }
    }
    report_layout.save_transaction(&save_proc)
    report_layout_id = report_layout.id
    report_layout_db = Report::ReportLayout.find_by_id(report_layout_id)
    return report_layout_db
  end

#  def self.add_or_modify_report_layout(doc)  
#    id =  parse_xml(doc/'id') if (doc/'id').first  
#    report_layout = Report::ReportLayout.find_or_create(id) 
#    return if !report_layout
#    report_layout.apply_attributes(doc) 
#    report_layout.fill_default_header_values() if report_layout.new_record? 
#    report_layout.build_lines(doc/:report_layout_columns/:report_layout_column)
#    report_layout.add_user_line_details(doc) if ( parse_xml(doc/'user_id')  )
##    report_layout.remove_duplicate_layout( parse_xml(doc/'name'), parse_xml(doc/'report_id')) if ( parse_xml(doc/'user_id')  ) and (parse_xml(doc/'layout_type')=='U')   #remove condition on sunday 20 june
#    return report_layout 
#  end


#def self.add_or_modify_report_layout(doc)  
#    id =  parse_xml(doc/'id') if (doc/'id').first  
#    report_layout = Report::ReportLayout.find_or_create(id) 
#    return if !report_layout
#    report_layout.apply_attributes(doc) 
#    report_layout.fill_default_header_values() if report_layout.new_record? 
#    report_layout.build_lines(doc/:report_layout_columns/:report_layout_column)
#    report_layout.add_user_line_details(doc) if ( parse_xml(doc/'user_id')  )
#    #and (parse_xml(doc/'layout_type')=='U')   remove condition on sunday 20 june
#    return report_layout 
#  end
#  
  
  #Newly Added on 01/09/2010
   def self.add_or_modify_report_layout(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first
    layout_type =  parse_xml(doc/'layout_type') if (doc/'layout_type').first  
    report_id =  parse_xml(doc/'report_id') if (doc/'report_id').first 
    name =  parse_xml(doc/'name') if (doc/'name').first 
    if((id.to_i > 0) || layout_type=='S')
      report_layout =  Report::ReportLayout.find_or_create(id) 
    elsif(layout_type=='U')
      if(id==nil || id.to_i == 0)
        report_layout = find_duplicate_layout(report_id,name)
        report_layout =  Report::ReportLayout.find_or_create(id) if report_layout.nil?        
      end      
    end
    return if !report_layout
    report_layout.apply_attributes(doc) 
    report_layout.fill_default_header_values() if report_layout.new_record? 
    report_layout.build_lines(doc/:report_layout_columns/:report_layout_column)
    report_layout.add_user_line_details(doc) if ( parse_xml(doc/'user_id')  )
    #and (parse_xml(doc/'layout_type')=='U')   remove condition on sunday 20 june
    return report_layout 
  end
  
  def self.list_system_user_layouts(doc)
    user_id =  parse_xml(doc/:criteria/'user_id') if (doc/:criteria/'user_id').first
    document_id =  parse_xml(doc/:criteria/'document_id') if (doc/:criteria/'document_id').first
    sql = "select report_layouts.id as id, report_layouts.name ,layout_type, lockedcolumncount,print_orientation,
                                       report_layouts.trans_flag,report_id,user_id, nvl(default_yn, 'N') as default_yn,#{document_id} as document_id from report_layouts
	                               left outer join report_layout_users on
	                               (report_layouts.id = report_layout_users.report_layout_id
		                       and report_layout_users.user_id = ?	)
                                       where report_layouts.report_id =(select id from reports where document_id=?)"
    sql = convert_sql_to_db_specific(sql)
    Report::ReportLayout.find_by_sql [sql,user_id.to_i,document_id.to_i]
  end
 
  def self.list_document_columns(doc)
    document_id =  parse_xml(doc/:criteria/'document_id') if (doc/:criteria/'document_id').first
    Report::ReportColumn.find_by_sql ["select * from report_columns where report_id= (select id from reports where document_id = ? )  order by column_label", document_id]
  end
  
   def self.find_duplicate_layout(report_id,name)
    layout = Report::ReportLayout.find_by_report_id_and_name(report_id,name)    
  end

  private_class_method :create_report, :add_or_modify_report ,:create_report_layout, :add_or_modify_report_layout

end