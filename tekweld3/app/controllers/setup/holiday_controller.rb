class Setup::HolidayController < ApplicationController
  include General
  include ClassMethods 
  require 'hpricot'
  
  #Service for Shipping
  def list_holidays
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @holidays = Setup::HolidayCrud.list_holidays(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@holidays[0].xmlcol))+'</encoded>'
  end  

  def show_holiday
    doc = Hpricot::XML(request.raw_post)
    holiday_id  = parse_xml(doc/:params/'id')
    @holidays = Setup::HolidayCrud.show_holiday(holiday_id)
    render_view( @holidays,'shippings','L')
  end  

  def create_holidays
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @holidays = Setup::HolidayCrud.create_holidays(doc)
    holiday =  @holidays.first if !@holidays.empty?
    if holiday.errors.empty?
      render_view(@holidays,'holidays','L') 
    else
      respond_to_errors(holiday.errors)
    end
  end
  
  def convert_exceltoxml_for_holidays
    uploaded_file = params[:Filedata]
    uploaded_file_name = params[:Filename]
    extension = uploaded_file.original_filename.split(".").last
    table_name = params[:table_name]
    #    IO::FileIO.save_xslx(uploaded_file) if extension=='xlsx'
    #    error_text,workbook = IO::FileIO.openexcelXfile(uploaded_file,uploaded_file_name) if extension=='xlsx'
    #    error_text,workbook = IO::FileIO.openexcelfile(uploaded_file,uploaded_file_name) if extension=='xls'
    #    if error_text
    #      render :text => error_text
    #      return
    #    end
    @data_rows = IO::FileIO.data_of_excel(uploaded_file)
    @tag_level1 = table_name.pluralize
    @tag_level2 = table_name.singularize
    render :template => "setup/holiday/convert_exceltoxml_for_holidays"
  end
end
