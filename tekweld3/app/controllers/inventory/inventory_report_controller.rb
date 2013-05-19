class Inventory::InventoryReportController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def issue_report
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @inventory_transactions = Inventory::InventoryTransactionReport.issue_report(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory_transactions[0]['xmlcol']))+'</encoded>'
  end
  
  def receieve_report
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @inventory_transactions= Inventory::InventoryTransactionReport.receieve_report(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory_transactions[0]['xmlcol']))+'</encoded>'
  end
  
  def stock_report
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @inventory = Inventory::InventoryTransactionReport.stock_report(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory[0]['xmlcol']))+'</encoded>'
  end
  
  def activity_report
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @inventory_transactions = Inventory::InventoryTransactionReport.activity_report(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory_transactions[0]['xmlcol']))+'</encoded>'
  end
  
  def backdated_stock_report
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #  xml = %{
    #                     <criteria>   
    #                      <str1></str1>   
    #                      <str2>zzzz</str2>   
    #                      <str3></str3>   
    #                      <str4>zzzzzzz</str4>   
    #                      <str5></str5>   
    #                      <str6>zzz</str6> 
    #                      <str7></str7>
    #                      <str8>zzz</str8> 
    #                      <str9></str9>
    #                      <str10></str10> 
    #                      <multiselect1></multiselect1>
    #                      <multiselect4></multiselect4>
    #                      <str12>zzz</str12>
    #                      <str14>zzz</str14>
    #                      <str16>zzz</str16>
    #                      <user_id>100</user_id>
    #                      <int1></int1>
    #                      <int2>999999</int2>
    #                      <default_request>N</default_request>
    #                      <dt1>2009-01-01 00:00:00</dt1>
    #                      <dt2>2050-01-01 00:00:00</dt2>
    #                     </criteria> 
    #      }
    #   doc = Hpricot::XML(xml)
    @inventory = Inventory::InventoryTransactionReport.backdated_stock_report(doc)
    #    render_view(@inventory,'backdated_stock_report','L')
    # respond_to_action('inventory_stock_report') 
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory[0]['xmlcol']))+'</encoded>'
    #    render :xml=>@inventory[0].xmlcol
  end
  
  def store_transfer_report
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
    #                    <str10>zzz</str10> 
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                      <user_id>100</user_id>
    #                    <default_request>N</default_request>
    #                   </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @inventory_transactions= Inventory::InventoryTransactionReport.store_transfer_report(doc)
    #    render_view(@inventory_transactions,'store_transfer_report','L') 
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory_transactions[0]['xmlcol']))+'</encoded>'
    #    render :xml=>@inventory_transactions[0].xmlcol
  end
  
  def all_store_stock_report
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
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                      <user_id>100</user_id>
    #                    <default_request>N</default_request>
    #                   </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @inventory= Inventory::InventoryTransactionReport.all_store_stock_report(doc)
    #    respond_to_action('inventory_stock_report') 
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory[0].xmlcol))+'</encoded>'
    #    render :xml=>@inventory[0].xmlcol
  end

  def stock_aging_detail_report
    doc = Hpricot::XML(request.raw_post)  
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #  xml = %{
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
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <user_id>100</user_id>
    #                    <default_request>N</default_request>
    #                   </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @inventory = Inventory::InventoryTransactionReport.stock_aging_detail_report(doc)
    #    respond_to_action('inventory_stock_report') 
    #    render_view(@inventory,"stock_aging_detail_report","L")
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory[0]['xmlcol']))+'</encoded>'
  end
  
  def stock_aging_summary_report
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #  xml = %{
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
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                    <user_id>100</user_id>
    #                    <default_request>N</default_request>
    #                   </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @inventory = Inventory::InventoryTransactionReport.stock_aging_summary_report(doc)
    #    respond_to_action('inventory_stock_report') 
    #    render_view(@inventory,"stock_aging_summary_report","L")
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory[0]['xmlcol']))+'</encoded>'
  end
  
  def stock_report_with_packet
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    #   xml = %{
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
    #                    <multiselect1></multiselect1>
    #                    <multiselect4></multiselect4>
    #                    <str12>zzz</str12>
    #                    <str14>zzz</str14>
    #                    <str16>zzz</str16>
    #                      <user_id>100</user_id>
    #                    <default_request>N</default_request>
    #                   </criteria> 
    #    }
    #    doc = Hpricot::XML(xml)
    @inventory= Inventory::InventoryTransactionReport.stock_packetwise_report(doc)
    #    respond_to_action('inventory_stock_report')
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory[0].xmlcol))+'</encoded>'
    #    render :xml=>@inventory[0].xmlcol
  end 
  
  def image_missing_report
    doc = Hpricot::XML(request.raw_post)   
    request_array = (request.host).split(".")
    company_code = request_array[0]
    company = Setup::Company.find_by_sql ["select schema_name from main.main_companies where code='#{company_code}' "]   if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter') 
    company = Setup::Company.find_by_sql ["select schema_name from main.dbo.main_companies where code='#{company_code}' "]   if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter') 
    schema_name = company.first.schema_name
    @missing_images = Inventory::InventoryTransactionReport.missing_image_report(doc,schema_name)
    render_view(@missing_images,'missing_image','L')
    #    render_to_string(@missing_images)
  end

  def render_jewelry_format 
    doc = Hpricot::XML(request.raw_post)
    catalog_item_id  = parse_xml(doc/:params/'id')
    schema_name = session[:schema]
    @catalog_items = Item::CatalogItemCrud.show_catalog_item(catalog_item_id)
    @types = Setup::Type.list_all_types(doc)
    @xml=  render_to_string(:template => 'inventory/item/show_catalog_item')
    doc = @xml.to_s
    puts doc
    filename = "poformat#{Time.now().strftime('%d%m%y%H%M%S')}"
    path = Setup::Type.find(:first, :conditions=>["type_cd = 'UPLOAD_FOLDER' and subtype_cd = 'REPORT_PRINT'"])
    if path 
      directory =  "#{Dir.getwd}" + path.value + schema_name  
    end
    puts filename
    FileUtils.mkdir_p(directory)
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    FileUtils.mkdir_p( "#{Dir.getwd}" + '/fop/xml/' + schema_name )
    File.open("#{Dir.getwd}/fop/xml/#{schema_name}/#{filename}.xml", 'w') {|f| f.write(doc) }
    command = "#{Dir.getwd}/fop/fop.bat #{Dir.getwd}/fop/xsl/jewelry.fo  #{Dir.getwd}/fop/xml/#{schema_name}/#{filename}.xml #{absolute_filename}"
    result = system command
    if result == true 
      @result="#{filename}.pdf"
    else
      @result='error.pdf'
    end
    render :template => "report/print_report/render_print_format"
  end

  #No reference foun in flex
  #  def variance_report
  #    doc = Hpricot::XML(request.raw_post)
  #    doc = doc.to_s.gsub("&amp;","&")
  #    doc = Hpricot::XML(doc)
  #    @inventory_transactions = Inventory::InventoryTransactionReport.variance_report(doc)
  #    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory_transactions[0].xmlcol))+'</encoded>'
  #  end
  
  def backdated_stock_variance_report
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @inventory_transactions = Inventory::InventoryTransactionReport.backdated_stock_variance_report(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@inventory_transactions[0]['xmlcol']))+'</encoded>'
  end

  
end
