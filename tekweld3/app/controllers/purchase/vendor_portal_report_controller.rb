require 'hpricot'
class Purchase::VendorPortalReportController < ApplicationController
  def open_orders 
     
    #     xml = %{
    #        <criteria>   
    #                <str1></str1>   
    #                <str2>zzz</str2>   
    #                <str3></str3>   
    #                <str4>zzz</str4>   
    #                <str5></str5>   
    #                <str6>zzzz</str6> 
    #                <str7></str7>
    #                <str8>zzzz</str8>
    #                <str9></str9> 
    #                <str10>zzzzz</str10> 
    #                <str11></str11>
    #                <str12>zzzz</str12>
    #                <multiselect2>103912</multiselect2>
    #                <default_request>N</default_request>
    #                <int1>226</int1>
    #                <int2>300</int2>
    #                <str15></str15>
    #                <str16>zzzz</str16>
    #                <str14>zzzzz</str14>
    #                <str13></str13>
    #        </criteria> 
    #      }
    #    doc = Hpricot::XML(xml)
    doc = Hpricot::XML(request.raw_post)  
    #    login_type='G'
    #    type_id='1'
    a=Admin::User.find((doc/:user_id).inner_html,:select=>"login_type,type_id")
    login_type, type_id =a.login_type,a.type_id
    @order_details = VendorPortal::VendorPortalReport.find_open_orders(doc,login_type, type_id)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@order_details[0].xmlcol))+'</encoded>'
  end
  
  def pending_orders_list  
    doc = Hpricot::XML(request.raw_post)   
    a=Admin::User.find((doc/:user_id).inner_html,:select=>"login_type,type_id")
    login_type, type_id =a.login_type,a.type_id
    #    xml = %{
    #        <criteria>   
    #                <str1></str1>   
    #                <str2>zzz</str2>   
    #                <str3></str3>   
    #                <str4>zzz</str4>   
    #                <str5></str5>   
    #                <str6>zzzz</str6> 
    #                <str7></str7>
    #                <str8>zzzz</str8>
    #                <str9></str9> 
    #                <str10>zzzzz</str10> 
    #                <str11></str11>
    #                <str12>zzzz</str12>
    #                <multiselect2>103912</multiselect2>
    #                <default_request>N</default_request>
    #                <int1>226</int1>
    #                <int2>300</int2>
    #                <str15></str15>
    #                <str16>zzzz</str16>
    #                <str14>zzzzz</str14>
    #                <str13></str13>
    #        </criteria> 
    #      }
    #     doc = Hpricot::XML(xml)
    ##   doc = Hpricot::XML(request.raw_post)  
    #     login_type='G'
    #     type_id='1'
    @order_details =  VendorPortal::VendorPortalReport.find_pending_orders(doc,login_type, type_id)   
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@order_details[0].xmlcol))+'</encoded>'
  end
  
   def overdue_po_report
     
    #     xml = %{
    #        <criteria>   
    #                <str1></str1>   
    #                <str2>zzz</str2>   
    #                <str3></str3>   
    #                <str4>zzz</str4>   
    #                <str5></str5>   
    #                <str6>zzzz</str6> 
    #                <str7></str7>
    #                <str8>zzzz</str8>
    #                <str9></str9> 
    #                <str10>zzzzz</str10> 
    #                <str11></str11>
    #                <str12>zzzz</str12>
    #                <multiselect2>103912</multiselect2>
    #                <default_request>N</default_request>
    #                <int1>226</int1>
    #                <int2>300</int2>
    #                <str15></str15>
    #                <str16>zzzz</str16>
    #                <str14>zzzzz</str14>
    #                <str13></str13>
    #        </criteria> 
    #      }
    #    doc = Hpricot::XML(xml)
    doc = Hpricot::XML(request.raw_post)  
    #    login_type='G'
    #    type_id='1'
    a=Admin::User.find((doc/:user_id).inner_html,:select=>"login_type,type_id")
    login_type, type_id =a.login_type,a.type_id
   @order_details = VendorPortal::VendorPortalReport.overdue_po_report(doc,login_type,type_id)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@order_details[0].xmlcol))+'</encoded>'    
  end
end
