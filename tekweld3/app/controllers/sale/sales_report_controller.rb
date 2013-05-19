class Sale::SalesReportController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  ## Tekweld Sales Order Stages Service
  def list_sales_order_stages
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesReport.list_sales_order_stages(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end
  
  ## Tekweld Standard Order Register Service
  def standard_order_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Sales::SalesReport.standard_order_register(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def list_user_activity
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesReport.list_user_activity(doc)
    respond_to_action('list_user_activity')
  end

  def list_incomplete_orders
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesReport.list_incomplete_orders(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def render_sales_order_format
    doc = Hpricot::XML(request.raw_post)     
    order_id  = parse_xml(doc/:params/'id')
    sales_order = Sales::SalesOrderShipping.active.find_all_by_sales_order_id(order_id)
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema] 
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path 
      directory =  "#{Dir.getwd}" + path.value + schema_name  
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    if sales_order[1]## detects whether the order contains multiple shipping
      rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'sorder_shipping'"])
      command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
    else  
      rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'sorder'"])
      command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
    end
    result = system command
    if result == true 
      @result="#{filename}.pdf"
    else
      @result='error.pdf'
    end
    render :template => "report/print_report/render_print_format"
  end
  
  def render_sales_reorder_format
    doc = Hpricot::XML(request.raw_post)     
    order_id  = parse_xml(doc/:params/'id')
    sales_order = Sales::SalesOrderShipping.active.find_all_by_sales_order_id(order_id)
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema] 
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path 
      directory =  "#{Dir.getwd}" + path.value + schema_name  
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    if sales_order[1]## detects whether the order contains multiple shipping
      rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'reorder_shipping'"])
      command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
    else
      rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'reorder'"])
      command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
    end
    result = system command
    if result == true 
      @result="#{filename}.pdf"
    else
      @result='error.pdf'
    end
    render :template => "report/print_report/render_print_format"
  end
  
  def render_sample_order_format
    doc = Hpricot::XML(request.raw_post)     
    order_id  = parse_xml(doc/:params/'id')
    sales_order = Sales::SalesOrderShipping.active.find_all_by_sales_order_id(order_id)
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema] 
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path 
      directory =  "#{Dir.getwd}" + path.value + schema_name  
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
   
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    if sales_order[1]## detects whether the order contains multiple shipping
      rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'sam_order_shipping'"])
      command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
    else
      rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'sample_order'"])
      command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
    end      
    result = system command
    if result == true 
      @result="#{filename}.pdf"
    else
      @result='error.pdf'
    end
    render :template => "report/print_report/render_print_format"
  end
  
  def render_virtual_order_format
    doc = Hpricot::XML(request.raw_post)     
    order_id  = parse_xml(doc/:params/'id')
    sales_order = Sales::SalesOrderShipping.active.find_all_by_sales_order_id(order_id)
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema] 
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path 
      directory =  "#{Dir.getwd}" + path.value + schema_name  
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    if sales_order[1]## detects whether the order contains multiple shipping
      rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'vir_order_shipping'"])
      command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
    else
      rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'virtual_order'"])
      command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
    end      
    result = system command
    if result == true 
      @result="#{filename}.pdf"
    else
      @result='error.pdf'
    end
    render :template => "report/print_report/render_print_format"
  end
  
  def render_sales_order_job_format
    doc = Hpricot::XML(request.raw_post)     
    order_id  = parse_xml(doc/:params/'id')
    sales_order = Sales::SalesOrder.active.find_by_id(order_id)
    sales_order_shipping = Sales::SalesOrderShipping.active.find_all_by_sales_order_id(order_id)
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema] 
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path 
      directory =  "#{Dir.getwd}" + path.value + schema_name  
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    if sales_order.trans_type == 'S' || sales_order.trans_type == 'F'
      if sales_order_shipping[1]## detects whether the order contains multiple shipping
        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'so_job_shipping'"])
        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
      else
        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'sales_order_job'"])
        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
      end
    elsif sales_order.trans_type == 'E' 
      if sales_order_shipping[1]## detects whether the order contains multiple shipping
        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'reorder_job_shipping'"])
        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"        
      else
        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'reorder_job'"])
        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"        
      end
    elsif sales_order.trans_type == 'P'
      if sales_order_shipping[1]## detects whether the order contains multiple shipping
        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'sm_job_shipping'"])
        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
      else
        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'sample_order_job'"])
        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
      end
    elsif sales_order.trans_type == 'V'
      if sales_order_shipping[1]## detects whether the order contains multiple shipping
        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'vo_job_shipping'"])
        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
      else
        rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'virtual_order_job'"])
        command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"  
      end
    end  
    result = system command
    if result == true 
      @result="#{filename}.pdf"
    else
      @result='error.pdf'
    end
    render :template => "report/print_report/render_print_format"
  end

  def open_order_report
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesReport.open_order_report(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0]['xmlcol']))+'</encoded>'
  end

  def payment_hold_report
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesReport.payment_hold_report(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def list_activity_detail_report
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @orders = Sales::SalesReport.list_activity_detail_report(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0]['xmlcol']))+'</encoded>'
    #    render :xml=> @orders[0][:xmlcol]
  end
end

