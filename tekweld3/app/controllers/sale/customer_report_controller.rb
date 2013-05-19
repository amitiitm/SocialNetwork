class Sale::CustomerReportController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  def customer_invoice_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #    xml = %{
    #            <criteria>
    #                    <user_id>100</user_id>
    #                    <str1></str1>
    #                    <str2>zzzz</str2>
    #                    <str3></str3>
    #                    <str4>zzzzzzz</str4>
    #                    <str5></str5>
    #                    <str6>zzz</str6>
    #                    <str7></str7>
    #                    <str8>zzz</str8>
    #                    <str9></str9>
    #                    <str10>zzzzz</str10>
    #                     <int2>9999</int2>
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>
    #
    #            </criteria>
    #    }
    #    doc = Hpricot::XML(xml)
    @invoices = Customer::CustomerReport.invoice_register(doc)
    #    respond_to_action('customer_invoice_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@invoices))+'</encoded>'
  end

  def customer_receipt_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #    xml = %{
    #            <criteria>
    #                    <user_id>100</user_id>
    #                    <str1></str1>
    #                    <str2>zzzz</str2>
    #                    <str3></str3>
    #                    <str4>zzzz</str4>
    #                    <str5></str5>
    #                    <str6>zzz</str6>
    #                    <str7></str7>
    #                    <str8>zzz</str8>
    #                    <str9></str9>
    #                    <str10>zzzzz</str10>
    #                    <int1></int1>
    #                     <int2>9999</int2>
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>z</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>
    #
    #            </criteria>
    #    }
    #    doc = Hpricot::XML(xml)
    @receipts = Customer::CustomerReport.receipt_register(doc)
    #    respond_to_action('customer_receipt_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@receipts))+'</encoded>'
  end

  def customer_credit_invoice_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #    xml = %{
    #            <criteria>
    #                    <user_id>100</user_id>
    #                    <str1></str1>
    #                    <str2>zzzz</str2>
    #                    <str3></str3>
    #                    <str4>zzz</str4>
    #                    <str5></str5>
    #                    <str6>zzz</str6>
    #                    <str7></str7>
    #                    <str8>zzz</str8>
    #                    <str9></str9>
    #                    <str10>zzzzz</str10>
    #                    <int1></int1>
    #                    <int2>9999</int2>
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>
    #
    #            </criteria>
    #    }
    #    doc = Hpricot::XML(xml)
    @receipts = Customer::CustomerReport.credit_invoice_register(doc)
    #    respond_to_action('customer_credit_invoice_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@receipts))+'</encoded>'
  end

  def customer_backdated_aging_report_detail
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #        xml = %{
    #                 <criteria>
    #                        <user_id>1 </user_id>
    #                        <str1></str1>
    #                        <str2>zzzz</str2>
    #                        <str3></str3>
    #                        <str4>zzzz</str4>
    #                        <str5></str5>
    #                        <str6>zzz</str6>
    #                        <str7>zz</str7>
    #                        <str8>z</str8>
    #                        <str9></str9>
    #                        <str10>zzzz</str10>
    #                        <int1></int1>
    #                        <int2>9999</int2>
    #                        <dt1>2050-01-01 00:00:00</dt1>
    #                        <dt3>2050-01-01 00:00:00</dt3>
    #                        <multiselect1></multiselect1>
    #                        <multiselect4></multiselect4>
    #                        <str12>zzz</str12>
    #                        <str14>zzz</str14>
    #                        <str16>zzz</str16>
    #                        <default_request>N</default_request>
    #                </criteria>
    #        }
    #        doc = Hpricot::XML(xml)
    @agings = Customer::CustomerReport.customer_aging_detail(doc)
    # respond_to_action('customer_credit_invoice_register')
    #    render_view(@agings,'customer_backdated_aging_detail','L')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@agings[0]['xmlcol']))+'</encoded>'
  end

  def customer_backdated_aging_summary
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #    xml = %{
    #                 <criteria>
    #                        <user_id>1 </user_id>
    #                        <str1></str1>
    #                        <str2>zzzz</str2>
    #                        <str3></str3>
    #                        <str4>zzzz</str4>
    #                        <str5></str5>
    #                        <str6>zzz</str6>
    #                        <str7>zz</str7>
    #                        <str8>z</str8>
    #                        <str9></str9>
    #                        <str10>zzzz</str10>
    #                        <int1></int1>
    #                        <int2>9999</int2>
    #                        <dt1>2050-01-01 00:00:00</dt1>
    #                        <dt3>2050-01-01 00:00:00</dt3>
    #                        <multiselect1></multiselect1>
    #                        <multiselect4></multiselect4>
    #                        <str12>zzz</str12>
    #                        <str14>zzz</str14>
    #                        <str16>zzz</str16>
    #                        <default_request>N</default_request>
    #                </criteria>
    #        }
    #        doc = Hpricot::XML(xml)
    @agings = Customer::CustomerReport.customer_aging_summary(doc)
    #respond_to_action('customer_credit_invoice_register')
    #    render_view(@agings,'customer_backdated_aging_summary','L')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@agings[0]['xmlcol']))+'</encoded>'
  end


  def customer_statement_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @customer_statements = Customer::CustomerReport.statement_register(doc)
    #    render_view(@customer_statements,'customer_statement','L')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customer_statements))+'</encoded>'
  end

  def customer_ledger_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @customer_ledger = Customer::CustomerReport.ledger_register(doc)
    #    render_view(@customer_ledger,'customer_ledger','L')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customer_ledger))+'</encoded>'
  end

  def customer_invoice_format
    doc = Hpricot::XML(request.raw_post)
    @result = Report::PrintReportCrud.render_format(doc, request.host.to_s, {})
    render :template => "report/print_report/render_print_format"
  end

  def customer_receipt_format
    doc = Hpricot::XML(request.raw_post)
    @result = Report::PrintReportCrud.render_format(doc, request.host.to_s, {})
    render :template => "report/print_report/render_print_format"
  end

  def customer_credit_invoice_format
    doc = Hpricot::XML(request.raw_post)
    @result = Report::PrintReportCrud.render_format(doc, request.host.to_s, {})
    render :template => "report/print_report/render_print_format"
  end

  ## Prototype services for customer info screen
  def customer_info_detail
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #    xml = %{<criterias><criteria><user_id>1</user_id>
    #          <str1></str1>
    #                        <str2>zzzz</str2>
    #                       <str3></str3>
    #                      <str4>zzzzzzz</str4> </criteria></criterias>}
    #    doc = Hpricot::XML(xml)
    @customer_info_details = Customer::CustomerReport.customer_info_detail(doc)
     render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customer_info_details[0]['xmlcol']))+'</encoded>'
  end

  def customer_label_format
    doc = Hpricot::XML(request.raw_post)
    cust_id  = parse_xml(doc/:params/'id')
    cust_ids = "\""+cust_id+"\""
    date_format = 'mm/dd/yyyy'
    schema_name = session[:schema]
    path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'tag_format' and subtype_cd = 'customer'"])
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    command = "#{Dir.getwd}/fop/printformatpdf.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{cust_ids} #{date_format} #{image_path}"
    result = system command
    if result == true
      @result="#{filename}.pdf"
    else
      @result='error.pdf'
    end
    render :template => "report/print_report/render_print_format"
  end

  def top_sales_format
    doc = Hpricot::XML(request.raw_post)
   
    from_customer_code =  parse_xml(doc/:params/'from_customer_code') == '' ? '""': parse_xml(doc/:params/'from_customer_code')
    from_date =  parse_xml(doc/:params/'from_date')
    to_date =  parse_xml(doc/:params/'to_date')
    request_array = (request.host).split(".")  #REPORT_CHANGE
    company_code = request_array[0]
    company = Setup::Company.find_by_sql ["select schema_name from main.main_companies where code='#{company_code}' "]   if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
    company = Setup::Company.find_by_sql ["select schema_name from main.dbo.main_companies where code='#{company_code}' "]   if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
    schema_name = company.first.schema_name
    company_id =  parse_xml(doc/:params/'company_id')
    company=Setup::Company.find_by_id(company_id)
    company.company_logo_file='blank.jpg' if (!company.company_logo_file || company.company_logo_file=='')
    company.business_card = 'blank.jpg' if (!company.business_card  || company.business_card=='')
    company.save!
    path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    #    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    image_path = "http://#{request.host}/images/#{schema_name}/"
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    command = "#{Dir.getwd}/fop/printtopsales.bat  #{schema_name}  #{absolute_filename} #{image_path} #{from_customer_code} #{from_date} #{to_date} "
    result = system command
    if result == true
      @result="#{filename}.pdf"
    else
      @result='error.pdf'
    end
    render :template => "report/print_report/render_print_format"
  end

end
