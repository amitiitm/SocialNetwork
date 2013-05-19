class Purchase::PurchaseReportController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  
  def render_purchase_order_format
    doc = Hpricot::XML(request.raw_post)     
    order_id  = parse_xml(doc/:params/'id')
    print_in_excel = parse_xml(doc/:params/'print_in_excel')
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema]
    purchase_order = Purchase::PurchaseOrder.find_by_id(order_id)
    company_id = purchase_order.company_id
    company=Setup::Company.find_by_id(company_id)
    Setup::CheckImageExistence.check_company_logo_existence(company,schema_name)
    Setup::CheckImageExistence.check_image_existence('purchase_orders','purchase_order_lines','purchase_order_id',order_id,schema_name)
    path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'porder'"])
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    if print_in_excel and print_in_excel=='Y'
      absolute_filename = File.join(directory, filename)+ "." + "xls"
      command = "#{Dir.getwd}/fop/printformatexcel.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{date_format} #{image_path}"
      result = system command
      if result == true
        @result="#{filename}.xls"
      else
        @result='error.pdf'
      end
    else
      absolute_filename = File.join(directory, filename)+ "." + "pdf"
      command = "#{Dir.getwd}/fop/printformatpdf.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{date_format} #{image_path}"
      result = system command
      if result == true
        @result="#{filename}.pdf"
      else
        @result='error.pdf'
      end
    end
    render :template => "report/print_report/render_print_format"
  end

  def render_purchase_invoice_format
    doc = Hpricot::XML(request.raw_post)     
    invoice_id  = parse_xml(doc/:params/'id')
    print_in_excel = parse_xml(doc/:params/'print_in_excel')
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema]
    purchase_invoice = Purchase::PurchaseInvoice.find_by_id(invoice_id)
    company_id = purchase_invoice.company_id
    company = Setup::Company.find_by_id(company_id)
    Setup::CheckImageExistence.check_company_logo_existence(company,schema_name)
    Setup::CheckImageExistence.check_image_existence('purchase_invoices','purchase_invoice_lines','purchase_invoice_id',invoice_id,schema_name)
    path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'pinvoice'"])
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    if print_in_excel and print_in_excel=='Y'
      absolute_filename = File.join(directory, filename)+ "." + "xls"
      command = "#{Dir.getwd}/fop/printformatexcel.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{invoice_id} #{date_format} #{image_path}"
      result = system command
      if result == true
        @result="#{filename}.xls"
      else
        @result='error.pdf'
      end
    else
      absolute_filename = File.join(directory, filename)+ "." + "pdf"
      command = "#{Dir.getwd}/fop/printformatpdf.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{invoice_id} #{date_format} #{image_path}"
      result = system command
      if result == true
        @result="#{filename}.pdf"
      else
        @result='error.pdf'
      end
    end
    render :template => "report/print_report/render_print_format"
  end

  def render_purchase_credit_invoice_format
    doc = Hpricot::XML(request.raw_post)     
    cr_invoice_id  = parse_xml(doc/:params/'id')
    print_in_excel = parse_xml(doc/:params/'print_in_excel')
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema]
    purchase_cr_invoice = Purchase::PurchaseCreditInvoice.find_by_id(cr_invoice_id)
    company_id = purchase_cr_invoice.company_id
    company = Setup::Company.find_by_id(company_id)
    Setup::CheckImageExistence.check_company_logo_existence(company,schema_name)
    path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'pcreditinvoice'"])
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    if print_in_excel and print_in_excel=='Y'
      absolute_filename = File.join(directory, filename)+ "." + "xls"
      command = "#{Dir.getwd}/fop/printformatexcel.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{cr_invoice_id} #{date_format} #{image_path}"
      result = system command
      if result == true
        @result="#{filename}.xls"
      else
        @result='error.pdf'
      end
    else
      absolute_filename = File.join(directory, filename)+ "." + "pdf"
      command = "#{Dir.getwd}/fop/printformatpdf.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{cr_invoice_id} #{date_format} #{image_path}"
      result = system command
      if result == true
        @result="#{filename}.pdf"
      else
        @result='error.pdf'
      end
    end
    render :template => "report/print_report/render_print_format"
  end

  def render_purchase_memo_format
    doc = Hpricot::XML(request.raw_post)     
    memo_id  = parse_xml(doc/:params/'id')
    print_in_excel = parse_xml(doc/:params/'print_in_excel')
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema]
    purchase_memo = Purchase::PurchaseMemo.find_by_id(memo_id)
    company_id = purchase_memo.company_id
    company=Setup::Company.find_by_id(company_id)
    Setup::CheckImageExistence.check_company_logo_existence(company,schema_name)
    path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'pmemo'"])
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    if print_in_excel and print_in_excel=='Y'
      absolute_filename = File.join(directory, filename)+ "." + "xls"
      command = "#{Dir.getwd}/fop/printformatexcel.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{memo_id} #{date_format} #{image_path}"
      result = system command
      if result == true
        @result="#{filename}.xls"
      else
        @result='error.pdf'
      end
    else
      absolute_filename = File.join(directory, filename)+ "." + "pdf"
      command = "#{Dir.getwd}/fop/printformatpdf.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{memo_id} #{date_format} #{image_path}"
      result = system command
      if result == true
        @result="#{filename}.pdf"
      else
        @result='error.pdf'
      end
    end
    render :template => "report/print_report/render_print_format"
  end

  def render_purchase_memo_return_format
    doc = Hpricot::XML(request.raw_post)     
    memo_return_id  = parse_xml(doc/:params/'id')
    print_in_excel = parse_xml(doc/:params/'print_in_excel')
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema]
    purchase_memo_return = Purchase::PurchaseMemoReturn.find_by_id(memo_return_id)
    company_id = purchase_memo_return.company_id
    company = Setup::Company.find_by_id(company_id)
    Setup::CheckImageExistence.check_company_logo_existence(company,schema_name)
    path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'pmemoreturn'"])
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    if print_in_excel and print_in_excel=='Y'
      absolute_filename = File.join(directory, filename)+ "." + "xls"
      command = "#{Dir.getwd}/fop/printformatexcel.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{memo_return_id} #{date_format} #{image_path}"
      result = system command
      if result == true
        @result="#{filename}.xls"
      else
        @result='error.pdf'
      end
    else
      absolute_filename = File.join(directory, filename)+ "." + "pdf"
      command = "#{Dir.getwd}/fop/printformatpdf.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{memo_return_id} #{date_format} #{image_path}"
      result = system command
      if result == true
        @result="#{filename}.pdf"
      else
        @result='error.pdf'
      end
    end
    render :template => "report/print_report/render_print_format"
  end

  #############report services

  def purchase_order_register
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #        xml = %{
    #                <criteria>
    #                        <str1></str1>
    #                        <str2>zzzz</str2>
    #                        <str3></str3>
    #                        <str4>zzzzzzz</str4>
    #                        <str5></str5>
    #                        <str6>zzz</str6>
    #                        <str7></str7>
    #                        <str8>zzz</str8>
    #                        <str9></str9>
    #                        <str10>zzzzz</str10>
    #                        <multiselect6></multiselect6>
    #                        <multiselect5>v005</multiselect5>
    #                        <str12>zzz</str12>
    #                        <str14>zzz</str14>
    #                        <str16>zzz</str16>
    #                        <default_request>N</default_request>
    #
    #                </criteria>
    #        }
    #        doc = Hpricot::XML(xml)
    @orders = Purchase::PurchaseReport.order_register(doc)
    #    respond_to_action('purchase_order_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0]['xmlcol']))+'</encoded>'
  end

  def purchase_invoice_register
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #        xml = %{
    #                <criteria>
    #                        <str1></str1>
    #                        <str2>zzzz</str2>
    #                        <str3></str3>
    #                        <str4>zzzzzzz</str4>
    #                        <str5></str5>
    #                        <str6>zzz</str6>
    #                        <str7></str7>
    #                        <str8>zzz</str8>
    #                        <str9></str9>
    #                        <dt1>2013-03-15 00:00:00<dt1>
    #                        <dt2>2025-12-31 00:00:00<dt2>
    #                        <str10>zzzzz</str10>
    #                        <multiselect1></multiselect1>
    #                        <multiselect4></multiselect4>
    #                        <str12>zzz</str12>
    #                        <str14>zzz</str14>
    #                        <str16>zzz</str16>
    #                        <default_request>N</default_request>
    #
    #                </criteria>
    #        }
    #        doc = Hpricot::XML(xml)
    @invoices = Purchase::PurchaseReport.invoice_register(doc)
    #    respond_to_action('purchase_invoice_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@invoices[0]['xmlcol']))+'</encoded>'
  end

  def purchase_credit_invoice_register
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #        xml = %{
    #                <criteria>
    #                        <str1></str1>
    #                        <str2>zzzz</str2>
    #                        <str3></str3>
    #                        <str4>zzzzzzz</str4>
    #                        <str5></str5>
    #                        <str6>zzz</str6>
    #                        <str7></str7>
    #                        <str8>zzz</str8>
    #                        <str9></str9>
    #                        <str10>zzzzz</str10>
    #                         <multiselect1></multiselect1>
    #                        <multiselect4></multiselect4>
    #                        <str12>zzz</str12>
    #                        <str14>zzz</str14>
    #                        <str16>zzz</str16>
    #                        <default_request>N</default_request>
    #
    #                </criteria>
    #        }
    #        doc = Hpricot::XML(xml)
    @credit_invoices = Purchase::PurchaseReport.credit_invoice_register(doc)
    #    respond_to_action('purchase_credit_invoice_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@credit_invoices[0]['xmlcol']))+'</encoded>'
  end

  def purchase_memo_register
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #        xml = %{
    #                <criteria>
    #                        <str1></str1>
    #                        <str2>zzzz</str2>
    #                        <str3></str3>
    #                        <str4>zzzzzzz</str4>
    #                        <str5></str5>
    #                        <str6>zzz</str6>
    #                        <str7></str7>
    #                        <str8>zzz</str8>
    #                        <str9></str9>
    #                        <str10>zzzzz</str10>
    #                        <multiselect1></multiselect1>
    #                        <multiselect4></multiselect4>
    #                        <str12>zzz</str12>
    #                        <str14>zzz</str14>
    #                        <str16>zzz</str16>
    #                        <default_request>N</default_request>
    #
    #                </criteria>
    #        }
    #        doc = Hpricot::XML(xml)
    @memos = Purchase::PurchaseReport.memo_register(doc)
    #    respond_to_action('purchase_memo_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@memos[0]['xmlcol']))+'</encoded>'
  end

  def purchase_memo_return_register
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #        xml = %{
    #                <criteria>
    #                        <str1></str1>
    #                        <str2>zzzz</str2>
    #                        <str3></str3>
    #                        <str4>zzzzzzz</str4>
    #                        <str5></str5>
    #                        <str6>zzz</str6>
    #                        <str7></str7>
    #                        <str8>zzz</str8>
    #                        <str9></str9>
    #                        <str10>zzzzz</str10>
    #                         <multiselect1></multiselect1>
    #                        <multiselect4></multiselect4>
    #                        <str12>zzz</str12>
    #                        <str14>zzz</str14>
    #                        <str16>zzz</str16>
    #                        <default_request>N</default_request>
    #
    #                </criteria>
    #        }
    #        doc = Hpricot::XML(xml)
    @memo_returns = Purchase::PurchaseReport.memo_return_register(doc)
    #    respond_to_action('purchase_memo_return_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@memo_returns[0]['xmlcol']))+'</encoded>'
  end

  def open_order_report
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #                 xml = %{
    #                       <criteria>
    #                        <str1></str1>
    #                        <str2>zzzz</str2>
    #                        <str3></str3>
    #                        <str4>zzzzzzz</str4>
    #                        <str5></str5>
    #                        <str6>zzz</str6>
    #                        <str7></str7>
    #                        <str8>zzz</str8>
    #                        <str9></str9>
    #                        <str10>zzz</str10>
    #                         <multiselect1></multiselect1>
    #                        <multiselect4></multiselect4>
    #                        <str12>zzz</str12>
    #                        <str14>z</str14>
    #                        <str16>zzz</str16>
    #                        <default_request>N</default_request>
    #                       </criteria>
    #        }
    #        doc = Hpricot::XML(xml)
    @orders = Purchase::PurchaseReport.open_order_report(doc)
    #    respond_to_action('purchase_order_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0]['xmlcol']))+'</encoded>'
  end

  def open_memo_report
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #     xml = %{
    #                       <criteria>
    #                        <str1></str1>
    #                        <str2>zzzz</str2>
    #                        <str3></str3>
    #                        <str4>zzzzzzz</str4>
    #                        <str5></str5>
    #                        <str6>zzz</str6>
    #                        <str7></str7>
    #                        <str8>zzz</str8>
    #                        <str9></str9>
    #                        <str10>zzz</str10>
    #                         <multiselect1></multiselect1>
    #                        <multiselect4></multiselect4>
    #                        <str12>zzzzzzzzzz</str12>
    #                        <str14>z</str14>
    #                        <str16>zzz</str16>
    #                          <str18>zzz</str18>
    #                        <default_request>N</default_request>
    #                       </criteria>
    #        }
    #        doc = Hpricot::XML(xml)
    @memos = Purchase::PurchaseReport.open_memo_report(doc)
    #    respond_to_action('purchase_memo_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@memos[0]['xmlcol']))+'</encoded>'
  end

  def open_invoice_report
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #    xml = %{
    #                   <criteria>
    #                    <str1></str1>
    #                    <str2>zzzz</str2>
    #                    <str3></str3>
    #                    <str4>zzzzzzz</str4>
    #                    <str5></str5>
    #                    <str6>zzz</str6>
    #                    <str7></str7>
    #                    <str8>zzz</str8>
    #                    <str9>M</str9>
    #                    <str10>M</str10>
    #                     <multiselect1>dave,sd</multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>
    #                   </criteria>
    #    }
    #    doc = Hpricot::XML(xml)
    @invoices = Purchase::PurchaseReport.open_invoice_report(doc)
    respond_to_action('purchase_invoice_register')
  end

  def purchase_cancel_order_register
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #xml = %{
    #                   <criteria>
    #                    <str1></str1>
    #                    <str2>zzzz</str2>
    #                    <str3></str3>
    #                    <str4>zzzzzzz</str4>
    #                    <str5></str5>
    #                    <str6>zzz</str6>
    #                    <str7></str7>
    #                    <str8>zzz</str8>
    #                    <str9></str9>
    #                    <str10></str10>
    #                     <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>
    #                   </criteria>
    #    }
    #    doc = Hpricot::XML(xml)
    @order_cancels = Purchase::PurchaseReport.cancel_order_register(doc)
    #    respond_to_action('purchase_cancel_order_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@order_cancels[0]['xmlcol']))+'</encoded>'
  end

  def purchase_indent_register
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #xml = %{
    #                   <criteria>
    #                    <str1></str1>
    #                    <str2>zzzz</str2>
    #                    <str3></str3>
    #                    <str4>zzzzzzz</str4>
    #                    <str5></str5>
    #                    <str6>zzz</str6>
    #                    <str7></str7>
    #                    <str8>zzz</str8>
    #                    <str9></str9>
    #                    <str10></str10>
    #                     <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>
    #                   </criteria>
    #    }
    #    doc = Hpricot::XML(xml)
    @order_cancels = Purchase::PurchaseReport.purchase_indent_report(doc)
    #    respond_to_action('purchase_cancel_order_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@order_cancels))+'</encoded>'
  end

  def open_purchase_indent_report
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #xml = %{
    #                   <criteria>
    #                    <str1></str1>
    #                    <str2>zzzz</str2>
    #                    <str3></str3>
    #                    <str4>zzzzzzz</str4>
    #                    <str5></str5>
    #                    <str6>zzz</str6>
    #                    <str7></str7>
    #                    <str8>zzz</str8>
    #                    <str9></str9>
    #                    <str10></str10>
    #                     <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>
    #                   </criteria>
    #    }
    #    doc = Hpricot::XML(xml)
    @order_cancels = Purchase::PurchaseReport.open_purchase_indent_report(doc)
    #    respond_to_action('purchase_cancel_order_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@order_cancels))+'</encoded>'
  end


  #purchase invoice register (One line)
  def purchase_invoice_register_one_line
    doc = Hpricot::XML(request.raw_post)     
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @invoices = Purchase::PurchaseReport.purchase_invoice_register_one_line(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@invoices[0]['xmlcol']))+'</encoded>'
  end


end

