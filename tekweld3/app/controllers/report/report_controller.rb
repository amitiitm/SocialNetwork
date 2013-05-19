class Report::ReportController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_reports
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @reports = Report::ReportCrud.list_reports(doc)
    respond_to_action('list_reports')
  end   
  
  def show_report
    doc = Hpricot::XML(request.raw_post)
    report_id  = parse_xml(doc/:params/'id')
    @reports = Report::ReportCrud.show_report(report_id)
    respond_to do |wants|
      wants.xml   
    end
  end  

  def create_reports
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @reports , @report_layouts = Report::ReportCrud.create_reports(doc)
    report =  @reports.first if !@reports.empty?
    #   report_layout =  @report_layouts.first if !@report_layouts.empty?
    if report.errors.empty? 
      respond_to_action('create_reports')
    else
      respond_to_errors(report.errors)
      
    end
  end  

  def list_report_layouts
    doc = Hpricot::XML(request.raw_post)  
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @report_layouts = Report::ReportCrud.list_report_layouts(doc)
    respond_to_action('list_report_layouts')
  end   
  
  def show_report_layout
    doc = Hpricot::XML(request.raw_post)
    report_layout_id  = parse_xml(doc/:params/'id')
    @report_layouts = Report::ReportCrud.show_report_layout(report_layout_id)
    respond_to do |wants|
      wants.xml   
    end
  end  
  
  def create_report_layouts
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @report_layouts= Report::ReportCrud.create_report_layouts(doc)
    report_layout =  @report_layouts.first if !@report_layouts.empty?
    if report_layout.errors.empty?
      respond_to_action('show_report_layout')
    else
      respond_to_errors(report_layout.errors)
    end
  end  
  
  def list_system_user_layouts
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    #    xml = %{
    #         <criteria>   
    #               <document_id>132</document_id>	
    #               <user_id>103</user_id>
    #               
    #         </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @report_layouts= Report::ReportCrud.list_system_user_layouts(doc)
    respond_to_action('list_system_user_layouts')
  end
  
  def list_document_columns
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    #     xml = %{
    #         <criteria>   
    #               <document_id>132</document_id>	
    #               
    #         </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @report_columns= Report::ReportCrud.list_document_columns(doc)
    respond_to_action('list_document_columns')
  end
  
end
