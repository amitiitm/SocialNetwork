class Purchase::PurchaseFixedReportController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def fixed_purchase_invoice_register
    doc = Hpricot::XML(request.raw_post)
    export_type  = parse_xml(doc/:print_data_params/'export_type')
    component_name = parse_xml(doc/:print_data_params/'component_name')
    schema_name = session[:schema]
    data = Purchase::PurchaseReport.invoice_register(doc/:print_data_params)
    xml = Hpricot::XML(data[0]['xmlcol'])
    is_data = parse_xml(xml/:purchase_invoices/:purchase_invoice)
    if is_data
      filename = "fix_format#{Time.now().strftime('%d%m%y%H%M%S')}"
      service_url = "http://#{request.env['HTTP_HOST']}/reports/#{schema_name}/#{filename}.xml"
      path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
      if path 
        directory =  "#{Dir.getwd}" + path.value + schema_name  
      end
      FileUtils.mkdir_p(directory)
      result_filename = export_type == 'PDF' ?  filename + "." + "pdf" : filename + "." + "xls"
      absolute_filename = export_type == 'PDF' ? File.join(directory, filename)+ "." + "pdf" : File.join(directory, filename)+ "." + "xls"
      File.open("#{directory}/#{filename}.xml", 'w') {|f| f.write(data[0]["xmlcol"]) }
      command =  "#{Dir.getwd}/ssrs/SSRS.bat #{Dir.getwd}/ssrs/RSScript_parameters.rss #{export_type}  #{absolute_filename} #{component_name} #{service_url}"      
      result = system command
      if result == true
        @result = result_filename
      else
        @result='Error'
      end
    else
      @result = 'No Record Found'
    end
    render :template => "report/print_report/render_print_format"
  end
  
  def fixed_purchase_order_register
    doc = Hpricot::XML(request.raw_post)
    export_type  = parse_xml(doc/:print_data_params/'export_type')
    component_name = parse_xml(doc/:print_data_params/'component_name')
    schema_name = session[:schema]
    data = Purchase::PurchaseReport.order_register(doc/:print_data_params)
    xml = Hpricot::XML(data[0]['xmlcol'])
    is_data = parse_xml(xml/:purchase_orders/:purchase_order)
    if is_data
      filename = "fix_format#{Time.now().strftime('%d%m%y%H%M%S')}"
      service_url = "http://#{request.env['HTTP_HOST']}/reports/#{schema_name}/#{filename}.xml"
      path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
      if path 
        directory =  "#{Dir.getwd}" + path.value + schema_name  
      end
      FileUtils.mkdir_p(directory)
      result_filename = export_type == 'PDF' ?  filename + "." + "pdf" : filename + "." + "xls"
      absolute_filename = export_type == 'PDF' ? File.join(directory, filename)+ "." + "pdf" : File.join(directory, filename)+ "." + "xls"
      File.open("#{directory}/#{filename}.xml", 'w') {|f| f.write(data[0]["xmlcol"]) }
      command =  "#{Dir.getwd}/ssrs/SSRS.bat #{Dir.getwd}/ssrs/RSScript_parameters.rss #{export_type}  #{absolute_filename} #{component_name} #{service_url} "      
      result = system command
      if result == true
        @result = result_filename
      else
        @result='Error'
      end
    else
      @result = 'No Record Found'
    end
    render :template => "report/print_report/render_print_format"
  end
  
  def fixed_purchase_open_order_register
    doc = Hpricot::XML(request.raw_post)
    export_type  = parse_xml(doc/:print_data_params/'export_type')
    component_name = parse_xml(doc/:print_data_params/'component_name')
    schema_name = session[:schema]
    data = Purchase::PurchaseReport.open_order_report(doc/:print_data_params)
    xml = Hpricot::XML(data[0]['xmlcol'])
    is_data = parse_xml(xml/:purchase_orders/:purchase_order)
    if is_data
      filename = "fix_format#{Time.now().strftime('%d%m%y%H%M%S')}"
      service_url = "http://#{request.env['HTTP_HOST']}/reports/#{schema_name}/#{filename}.xml"
      path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
      if path 
        directory =  "#{Dir.getwd}" + path.value + schema_name  
      end
      FileUtils.mkdir_p(directory)
      result_filename = export_type == 'PDF' ?  filename + "." + "pdf" : filename + "." + "xls"
      absolute_filename = export_type == 'PDF' ? File.join(directory, filename)+ "." + "pdf" : File.join(directory, filename)+ "." + "xls"
      File.open("#{directory}/#{filename}.xml", 'w') {|f| f.write(data[0]["xmlcol"]) }
      command =  "#{Dir.getwd}/ssrs/SSRS.bat #{Dir.getwd}/ssrs/RSScript_parameters.rss #{export_type}  #{absolute_filename} #{component_name} #{service_url} "      
      result = system command
      if result == true
        @result = result_filename
      else
        @result='Error'
      end
    else
      @result = 'No Record Found'
    end
    render :template => "report/print_report/render_print_format"
  end
  
  def fixed_purchase_memo_register
    doc = Hpricot::XML(request.raw_post)
    export_type  = parse_xml(doc/:print_data_params/'export_type')
    component_name = parse_xml(doc/:print_data_params/'component_name')
    schema_name = session[:schema]
    data = Purchase::PurchaseReport.memo_register(doc/:print_data_params)
    xml = Hpricot::XML(data[0]['xmlcol'])
    is_data = parse_xml(xml/:purchase_memos/:purchase_memo)
    if is_data
      filename = "fix_format#{Time.now().strftime('%d%m%y%H%M%S')}"
      service_url = "http://#{request.env['HTTP_HOST']}/reports/#{schema_name}/#{filename}.xml"
      path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
      if path 
        directory =  "#{Dir.getwd}" + path.value + schema_name  
      end
      FileUtils.mkdir_p(directory)
      result_filename = export_type == 'PDF' ?  filename + "." + "pdf" : filename + "." + "xls"
      absolute_filename = export_type == 'PDF' ? File.join(directory, filename)+ "." + "pdf" : File.join(directory, filename)+ "." + "xls"
      File.open("#{directory}/#{filename}.xml", 'w') {|f| f.write(data[0]["xmlcol"]) }
      command =  "#{Dir.getwd}/ssrs/SSRS.bat #{Dir.getwd}/ssrs/RSScript_parameters.rss #{export_type}  #{absolute_filename} #{component_name} #{service_url}"      
      result = system command
      if result == true
        @result = result_filename
      else
        @result='Error'
      end
    else
      @result = 'No Record Found'
    end
    render :template => "report/print_report/render_print_format"
  end
  
  def fixed_purchase_credit_invoice_register
    doc = Hpricot::XML(request.raw_post)
    export_type  = parse_xml(doc/:print_data_params/'export_type')
    component_name = parse_xml(doc/:print_data_params/'component_name')
    schema_name = session[:schema]
    data = Purchase::PurchaseReport.credit_invoice_register(doc/:print_data_params)
    xml = Hpricot::XML(data[0]['xmlcol'])
    is_data = parse_xml(xml/:purchase_credit_invoices/:purchase_credit_invoice)
    if is_data
      filename = "fix_format#{Time.now().strftime('%d%m%y%H%M%S')}"
      service_url = "http://#{request.env['HTTP_HOST']}/reports/#{schema_name}/#{filename}.xml"
      path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
      if path 
        directory =  "#{Dir.getwd}" + path.value + schema_name  
      end
      FileUtils.mkdir_p(directory)
      result_filename = export_type == 'PDF' ?  filename + "." + "pdf" : filename + "." + "xls"
      absolute_filename = export_type == 'PDF' ? File.join(directory, filename)+ "." + "pdf" : File.join(directory, filename)+ "." + "xls"
      File.open("#{directory}/#{filename}.xml", 'w') {|f| f.write(data[0]["xmlcol"]) }
      command =  "#{Dir.getwd}/ssrs/SSRS.bat #{Dir.getwd}/ssrs/RSScript_parameters.rss #{export_type}  #{absolute_filename} #{component_name} #{service_url}"      
      result = system command
      if result == true
        @result = result_filename
      else
        @result='Error'
      end
    else
      @result = 'No Record Found'
    end
    render :template => "report/print_report/render_print_format"
  end
  
  def fixed_purchase_open_memo_report
    doc = Hpricot::XML(request.raw_post)
    export_type  = parse_xml(doc/:print_data_params/'export_type')
    component_name = parse_xml(doc/:print_data_params/'component_name')
    schema_name = session[:schema]
    data = Purchase::PurchaseReport.open_memo_report(doc/:print_data_params)
    xml = Hpricot::XML(data[0]['xmlcol'])
    is_data = parse_xml(xml/:purchase_memos/:purchase_memo)
    if is_data
      filename = "fix_format#{Time.now().strftime('%d%m%y%H%M%S')}"
      service_url = "http://#{request.env['HTTP_HOST']}/reports/#{schema_name}/#{filename}.xml"
      path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
      if path 
        directory =  "#{Dir.getwd}" + path.value + schema_name  
      end
      FileUtils.mkdir_p(directory)
      result_filename = export_type == 'PDF' ?  filename + "." + "pdf" : filename + "." + "xls"
      absolute_filename = export_type == 'PDF' ? File.join(directory, filename)+ "." + "pdf" : File.join(directory, filename)+ "." + "xls"
      File.open("#{directory}/#{filename}.xml", 'w') {|f| f.write(data[0]["xmlcol"]) }
      command =  "#{Dir.getwd}/ssrs/SSRS.bat #{Dir.getwd}/ssrs/RSScript_parameters.rss #{export_type}  #{absolute_filename} #{component_name} #{service_url}"      
      result = system command
      if result == true
        @result = result_filename
      else
        @result='Error'
      end
    else
      @result = 'No Record Found'
    end
    render :template => "report/print_report/render_print_format"
  end
  
  def fixed_purchase_order_cancellation_report
    doc = Hpricot::XML(request.raw_post)
    export_type  = parse_xml(doc/:print_data_params/'export_type')
    component_name = parse_xml(doc/:print_data_params/'component_name')
    schema_name = session[:schema]
    data = Purchase::PurchaseReport.cancel_order_register(doc/:print_data_params)
    xml = Hpricot::XML(data[0]['xmlcol'])
    is_data = parse_xml(xml/:purchase_order_cancelss/:purchase_order_cancels)
    if is_data
      filename = "fix_format#{Time.now().strftime('%d%m%y%H%M%S')}"
      service_url = "http://#{request.env['HTTP_HOST']}/reports/#{schema_name}/#{filename}.xml"
      path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
      if path 
        directory =  "#{Dir.getwd}" + path.value + schema_name  
      end
      FileUtils.mkdir_p(directory)
      result_filename = export_type == 'PDF' ?  filename + "." + "pdf" : filename + "." + "xls"
      absolute_filename = export_type == 'PDF' ? File.join(directory, filename)+ "." + "pdf" : File.join(directory, filename)+ "." + "xls"
      File.open("#{directory}/#{filename}.xml", 'w') {|f| f.write(data[0]["xmlcol"]) }
      command =  "#{Dir.getwd}/ssrs/SSRS.bat #{Dir.getwd}/ssrs/RSScript_parameters.rss #{export_type}  #{absolute_filename} #{component_name} #{service_url}"      
      result = system command
      if result == true
        @result = result_filename
      else
        @result='Error'
      end
    else
      @result = 'No Record Found'
    end
    render :template => "report/print_report/render_print_format"
  end
  
end
