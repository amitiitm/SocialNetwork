class Account::GeneralLedgerReportController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def bank_deposit_register
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #     xml = %{
    #                           <criteria>   
    #                            <str1></str1>   
    #                            <str2>zzzz</str2>   
    #                            <str3></str3>   
    #                            <str4>zzzzzzz</str4>   
    #                            <str5></str5>   
    #                            <str6>zzzz</str6> 
    #                            <str7></str7>
    #                            <str8>zzz</str8> 
    #                            <str9></str9>
    #                            <str10>zzz</str10> 
    #                            <multiselect1></multiselect1>
    #                            <multiselect4></multiselect4>
    #                            <str12>zzz</str12>
    #                            <str14>zzz</str14>
    #                            <str16>zzz</str16>
    #                            <str18>zzz</str18>
    #                            <str20>zzz</str20>
    #                            <user_id>1</user_id>
    #                            <default_request>N</default_request>
    #                           </criteria> 
    #            }
    #    doc = Hpricot::XML(xml)
    @bank_transactions = GeneralLedger::BankTransactionReport.deposit_register(doc)
    #    respond_to_action('bank_transaction_report')  
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_transactions[0]['xmlcol']))+'</encoded>'
  end  

  def bank_payment_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #     xml = %{
    #                           <criteria>   
    #                            <str1></str1>   
    #                            <str2>zzzz</str2>   
    #                            <str3></str3>   
    #                            <str4>zzzzzzz</str4>   
    #                            <str5></str5>   
    #                            <str6>zzz</str6> 
    #                            <str7></str7>
    #                            <str8>zzz</str8> 
    #                            <str9></str9>
    #                            <str10>zzz</str10> 
    #                             <multiselect1></multiselect1>
    #                            <multiselect4></multiselect4>
    #                            <str12>zzz</str12>
    #                            <str14>z</str14>
    #                            <str16>zzz</str16>
    #                            <str18>zzz</str18>
    #                          <user_id>1</user_id>
    #                            <default_request>N</default_request>
    #                           </criteria> 
    #            }
    #            doc = Hpricot::XML(xml)
    @bank_transactions = GeneralLedger::BankTransactionReport.payment_register(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_transactions[0]['xmlcol']))+'</encoded>'
  end  

  def bank_transfer_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #   xml = %{
    #                           <criteria>   
    #                            <str1></str1>   
    #                            <str2>zzzz</str2>   
    #                            <str3></str3>   
    #                            <str4>zzzzzzz</str4>   
    #                            <str5></str5>   
    #                            <str6>zzz</str6> 
    #                            <str7></str7>
    #                            <str8>zzz</str8> 
    #                            <str9></str9>
    #                            <str10>zzz</str10> 
    #                             <multiselect1></multiselect1>
    #                            <multiselect4></multiselect4>
    #                            <str12>zzz</str12>
    #                            <str14>z</str14>
    #                            <str16>zzz</str16>
    #                            <str18>zzz</str18>
    #                            <str20>zzz</str20>
    #                          <user_id>1</user_id>
    #                            <default_request>N</default_request>
    #                           </criteria> 
    #            }
    #            doc = Hpricot::XML(xml)
    @bank_transactions = GeneralLedger::BankTransactionReport.transfer_register(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_transactions[0]['xmlcol']))+'</encoded>'
  end  

  def bank_transaction_register
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #   xml = %{
    #                           <criteria>   
    #                            <str1></str1>   
    #                            <str2>zzzz</str2>   
    #                            <str3></str3>   
    #                            <str4>zzzzzzz</str4>   
    #                            <str5></str5>   
    #                            <str6>zzz</str6> 
    #                            <str7></str7>
    #                            <str8>zzz</str8> 
    #                            <str9></str9>
    #                            <str10>zzz</str10> 
    #                             <multiselect1></multiselect1>
    #                            <multiselect4></multiselect4>
    #                            <str12>zzz</str12>
    #                            <str14>z</str14>
    #                            <str16>zzz</str16>
    #                            <str18>zzz</str18>
    #                            <str20>zzz</str20>
    #                          <user_id>1</user_id>
    #                            <default_request>N</default_request>
    #                           </criteria> 
    #            }
    #            doc = Hpricot::XML(xml)
    @bank_transactions = GeneralLedger::BankTransactionReport.transaction_register(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_transactions[0]['xmlcol']))+'</encoded>'
  end  

  def journal_register
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    # xml = %{
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
    #                        <multiselect1></multiselect1>
    #                        <multiselect4></multiselect4>
    #                        <str12>zzz</str12>
    #                        <str14>z</str14>
    #                        <str16>zzz</str16>
    #                         <user_id>100</user_id>
    #                        <default_request>N</default_request>
    #                       </criteria> 
    #        }
    #        doc = Hpricot::XML(xml)
    @bank_transactions = GeneralLedger::BankTransactionReport.journal_register(doc)
    #    respond_to_action('journal_register')  
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_transactions[0]['xmlcol']))+'</encoded>'
  end  

  def general_ledger_summary
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #    xml = %{
    #            <criteria> 
    #                    <user_id>100</user_id>
    #                    <str1></str1>   
    #                    <str2>zzzz</str2>   
    #                    <str3></str3>   
    #                    <str4>zz</str4>   
    #                    <str5></str5>   
    #                    <str6>zzz</str6> 
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <default_request>N</default_request>                    
    #            </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @gl_summaries = GeneralLedger::GlReport.general_ledger_summary(doc)
    #    respond_to_action('general_ledger_summary')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@gl_summaries))+'</encoded>'
  end
  
  def general_ledger_detail
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #    xml = %{
    #            <criteria> 
    #                    <user_id>100</user_id>
    #                    <str1></str1>   
    #                    <str2>zzz</str2>   
    #                    <str3></str3>   
    #                    <str4>zzz</str4>   
    #                    <str5></str5>   
    #                    <str6>zz</str6> 
    #                    <str7></str7>
    #                    <str8>zz</str8> 
    #                    <str9>zzz</str9>
    #                    <str10>zzzzz</str10> 
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
    @gl_summaries = GeneralLedger::GlReport.general_ledger_detail(doc)
    #    respond_to_action('general_ledger_summary')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@gl_summaries))+'</encoded>'
  end
  
  def trial_balance_summary
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #    xml = %{
    #            <criteria> 
    #                    <user_id>100</user_id>
    #                    <str1></str1>   
    #                    <str2>zzz</str2>   
    #                    <str3></str3>   
    #                    <str4>zzzz</str4>   
    #                    <str5>a</str5>   
    #                    <str6>zzz</str6> 
    #                    <str7>zzzzz</str7>
    #                    <str8></str8> 
    #                    <str9>zzz</str9>
    #                    <str10>zzzzz</str10> 
    #                    <int2>9999</int2>
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <int1>0</int1>
    #                    <int2>9999</int2>
    #                    <default_request>N</default_request>                    
    #            </criteria>
    #    }
    #    doc = Hpricot::XML(xml)
    @gl_summaries = GeneralLedger::GlReport.trial_balance_summary(doc)
    #    respond_to_action('general_ledger_summary')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@gl_summaries))+'</encoded>'
  end
  
  def trial_balance_detail
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #    xml = %{
    #            <criteria> 
    #                    <user_id>100</user_id>
    #                    <str1></str1>   
    #                    <str2>zzz</str2>   
    #                    <str3></str3>   
    #                    <str4>zzzz</str4>   
    #                    <str5>a</str5>   
    #                    <str6>zzz</str6> 
    #                    <str7>zzzzz</str7>
    #                    <str8></str8> 
    #                    <str9>zzz</str9>
    #                    <str10>zzzzz</str10> 
    #                    <int2>9999</int2>
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <int1>0</int1>
    #                    <int2>9999</int2>
    #                    <default_request>N</default_request>                    
    #            </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @gl_summaries = GeneralLedger::GlReport.trial_balance_detail(doc)
    #    respond_to_action('general_ledger_summary')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@gl_summaries))+'</encoded>'
  end
  
  def bank_payment_format
    #    xml = %{
    #            <params>
    #              <id>7</id>   
    #            </params>      }    
    #    doc = Hpricot::XML(xml) 
    doc = Hpricot::XML(request.raw_post) 
    schema_name = session[:schema] 
    bank_id  = parse_xml(doc/:params/'id')    
    @payments,@payment_lines = GeneralLedger::BankTransactionReport.bank_payment_format(bank_id)     
    @xml = render_to_string(:template => 'account/general_ledger_report/show_bank_payment_format')   
    doc = @xml.to_s
    filename = "bank_payment_format#{Time.now().strftime('%d%m%y%H%M%S')}"
    path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
    if path 
      directory =  "#{Dir.getwd}" + path.value + schema_name            
    end
    puts filename
    FileUtils.mkdir_p(directory)
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    FileUtils.mkdir_p( "#{Dir.getwd}" + '/fop/xml/' + schema_name )
    File.open("#{Dir.getwd}/fop/xml/#{schema_name}/#{filename}.xml", 'w') {|f| f.write(doc) }
    #    command = "fop -xsl #{Dir.getwd}/fop/xsl/diam_invoice -xml #{Dir.getwd}/fop/xml/#{filename}.xml -pdf #{absolute_filename}"
    #     upper command will not work properly amit
    command = "#{Dir.getwd}/fop/fop.bat  #{Dir.getwd}/fop/xsl/bank_payment.fo  #{Dir.getwd}/fop/xml/#{schema_name}/#{filename}.xml #{absolute_filename}"
    result = system command
    if result == true 
      #render :text => "#{Dir.getwd}/fop/pdf/employee.pdf"
      @result="#{filename}.pdf"
    else
      #render :text => 'error'
      @result='error.pdf'
    end
    render :template => "report/print_report/render_print_format"
  end

  #Bank balance report added on  21 march 2011 by Minal Jain
  
  def bank_balance_report
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #     xml = %{
    #                           <criteria>   
    #                            <str1></str1>   
    #                            <str2>zzzz</str2>   
    #                            <str3></str3>   
    #                            <str4>zzzzzzz</str4>   
    #                            <str5>a</str5>   
    #                            <str6>b</str6> 
    #                            <str7></str7>
    #                            <str8>zzz</str8> 
    #                            <dt2>2025-12-25</dt2>
    #                            <str10>zzz</str10> 
    #                             <multiselect1></multiselect1>
    #                            <multiselect4></multiselect4>
    #                            <str12>zzz</str12>
    #                            <str14>z</str14>
    #                            <str16>zzz</str16>
    #                            <user_id>1</user_id>
    #                            <default_request>N</default_request>
    #                           </criteria> 
    #            }
    #            doc = Hpricot::XML(xml)
    @bank_transactions = GeneralLedger::BankTransactionReport.bank_balance_report(doc)
    #    respond_to_action('bank_balance_report')  
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@bank_transactions[0]['xmlcol']))+'</encoded>'
  end  
end
