class Purchase::VendorInfoController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def vendor_open_memos
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    #         xml = %{
    #                           <criteria>   
    #                            <str1>19</str1>   
    #                            <str2>zzzz</str2>   
    #                            <str3></str3>   
    #                            <str4>zzzzzzz</str4>   
    #                            <str5></str5>   
    #                            <str6>zzz</str6> 
    #                            <str7></str7>
    #                            <str8>zzz</str8> 
    #                            <str9></str9>
    #                            <str10>zzz</str10> 
    #                           <vendor_id>1</vendor_id>
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
    @vendors = VendorInfo::VendorInfoCrud.vendor_open_memos(doc)    
    respond_to_action('vendor_info')
  end
  
  def vendor_memos
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @vendors = VendorInfo::VendorInfoCrud.vendor_memos(doc)  
    respond_to_action('vendor_info')    
  end
  
  def vendor_invoice_summary
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @vendors = VendorInfo::VendorInfoCrud.vendor_invoice_summary(doc)       
    respond_to_action('vendor_info')    
  end
  
  def vendor_invoice_by_item
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @vendors = VendorInfo::VendorInfoCrud.vendor_invoice_by_item(doc) 
    respond_to_action('vendor_info')    
  end
  
  def vendor_credit_invoice_summary
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc) 
    @vendors = VendorInfo::VendorInfoCrud.vendor_credit_invoice_summary(doc)  
    respond_to_action('vendor_info')
  end

  def vendor_credit_invoice_by_item
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc) 
    @vendors = VendorInfo::VendorInfoCrud.vendor_credit_invoice_by_item(doc)     
    respond_to_action('vendor_info')    
  end
  
  def vendor_open_order
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @vendors = VendorInfo::VendorInfoCrud.vendor_open_order(doc)    
    respond_to_action('vendor_info')
  end
  
  def vendor_orders
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @vendors = VendorInfo::VendorInfoCrud.vendor_orders(doc)    
    respond_to_action('vendor_info')
  end
  
   
  def vendor_open_receipts
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @vendors = VendorInfo::VendorInfoCrud.vendor_open_receipts(doc)    
    respond_to_action('vendor_info')    
  end
  
  def vendor_open_credits
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @vendors = VendorInfo::VendorInfoCrud.vendor_open_credits(doc)    
    respond_to_action('vendor_info')
  end
  
  def vendor_receipts
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @vendors = VendorInfo::VendorInfoCrud.vendor_receipts(doc)    
    respond_to_action('vendor_info')
  end
  
  def vendor_credits
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @vendors = VendorInfo::VendorInfoCrud.vendor_credits(doc)    
    respond_to_action('vendor_info')
  end
  
  def vendor_aging
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @vendors = VendorInfo::VendorInfoCrud.vendor_aging(doc)    
    respond_to_action('vendor_info')
  end
  
end
