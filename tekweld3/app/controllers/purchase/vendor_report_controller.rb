class Purchase::VendorReportController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def vendor_invoice_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #    xml = %{
    #            <criteria>   
    #                    <user_id>100 </user_id>
    #                    <str1></str1>   
    #                    <str2>zzzz</str2>   
    #                    <str3></str3>   
    #                    <str4>zzzz</str4>   
    #                    <str5></str5>   
    #                    <str6>zzz</str6> 
    #                    <str7></str7>
    #                    <str8>z</str8> 
    #                    <str9></str9>
    #                    <str10>zzzz</str10> 
    #                    <int1></int1>
    #                    <int2>9999</int2>
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12></str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>                    
    #            </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @invoices = Vendor::VendorReport.invoice_register(doc)
    #    respond_to_action('vendor_invoice_register')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@invoices))+'</encoded>'
  end

  def vendor_payment_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)     
    #    xml = %{
    #            <criteria>   
    #                    <user_id>100 </user_id>
    #                    <str1></str1>   
    #                    <str2>zzzz</str2>   
    #                    <str3></str3>   
    #                    <str4>zzzz</str4>   
    #                    <str5></str5>   
    #                    <str6>zzz</str6> 
    #                    <str7></str7>
    #                    <str8>z</str8> 
    #                    <str9></str9>
    #                    <str10>zzzz</str10> 
    #                    <int1></int1>
    #                    <int2>9999</int2>
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12></str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>                    
    #            </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @payments = Vendor::VendorReport.payment_register(doc)
    #    respond_to_action('vendor_payment_register')  
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@payments))+'</encoded>'
  end
  def vendor_credit_invoice_register
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)     
    #    xml = %{
    #            <criteria>   
    #                    <user_id>100 </user_id>
    #                    <str1></str1>   
    #                    <str2>zzzz</str2>   
    #                    <str3></str3>   
    #                    <str4>zzzz</str4>   
    #                    <str5></str5>   
    #                    <str6>zzz</str6> 
    #                    <str7></str7>
    #                    <str8>z</str8> 
    #                    <str9></str9>
    #                    <str10>zzzz</str10> 
    #                    <int1></int1>
    #                    <int2>9999</int2>
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>                    
    #            </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @payments = Vendor::VendorReport.credit_invoice_register(doc)
    #    respond_to_action('vendor_payment_register') 
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@payments))+'</encoded>'
  end

  def vendor_backdated_aging_detail
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    #        xml = %{
    #                <criteria>   
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
    @agings = Vendor::VendorReport.vendor_aging_detail(doc)
    #    render_view(@agings,'vendor_backdated_aging_detail','L')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@agings[0]['xmlcol']))+'</encoded>'
  end
  
  def vendor_backdated_aging_summary
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    #   xml = %{
    #                <criteria>   
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
    @agings = Vendor::VendorReport.vendor_aging_summary(doc)
    #    render_view(@agings,'vendor_backdated_aging_summary','L')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@agings[0]['xmlcol']))+'</encoded>'
  end

  def vendor_statement_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @vendor_statement = Vendor::VendorReport.statement_register(doc)
    #    render_view(@vendor_statement,'vendor_statement','L')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@vendor_statement))+'</encoded>'
  end

  def vendor_invoice_format
    doc = Hpricot::XML(request.raw_post) 
    @result = Report::PrintReportCrud.render_format(doc,request.host.to_s, {})
    render :template => "report/print_report/render_print_format"
  end
 
  def vendor_credit_invoice_format
    doc = Hpricot::XML(request.raw_post)
    @result = Report::PrintReportCrud.render_format(doc,request.host.to_s, {})
    render :template => "report/print_report/render_print_format"
  end

  def vendor_payment_format
    doc = Hpricot::XML(request.raw_post) 
    @result = Report::PrintReportCrud.render_format(doc,request.host.to_s, {})
    render :template => "report/print_report/render_print_format"
  end

  def vendor_ledger_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #    xml = %{
    #            <criteria>   
    #                    <user_id>100 </user_id>
    #                    <str1></str1>   
    #                    <str2>zzzz</str2>   
    #                    <str3></str3>   
    #                    <str4>zzzz</str4>   
    #                    <str5></str5>   
    #                    <str6>zzz</str6> 
    #                    <str7></str7>
    #                    <str8>z</str8> 
    #                    <str9></str9>
    #                    <str10>zzzz</str10> 
    #                    <int1></int1>
    #                    <int2>9999</int2>
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12></str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <default_request>N</default_request>                    
    #            </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @vendor_ledger = Vendor::VendorReport.ledger_register(doc)
    #    render_view(@vendor_ledger,'vendor_ledger','L')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@vendor_ledger))+'</encoded>'
  end
  
  def vendor_info_detail
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #    xml = %{<criterias><criteria><user_id>1</user_id>
    #          <str1></str1>
    #                        <str2>zzzz</str2>
    #                       <str3></str3>
    #                      <str4>zzzzzzz</str4> </criteria></criterias>}
    #    doc = Hpricot::XML(xml)
    @vendor_info_details = Vendor::VendorReport.vendor_info_detail(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@vendor_info_details[0]['xmlcol']))+'</encoded>'
  end

  
end
