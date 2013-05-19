require'hpricot'
class Purchase::VendorPortalController < ApplicationController
  def po_inbox
    doc = Hpricot::XML(request.raw_post)   
    admin = Admin::User.find((doc/:user_id).inner_html,:select=>"login_type,type_id")
    login_type, type_id = admin.login_type,admin.type_id
    @order = []
    @order = VendorPortal::VendorPortalCrud.unacknowledged_orders(doc,login_type,type_id)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@order[0].xmlcol))+'</encoded>'
  end
  
  def po_accept_inbox
    doc = Hpricot::XML(request.raw_post)   
    admin = Admin::User.find((doc/:user_id).inner_html,:select=>"login_type,type_id")
    login_type, type_id = admin.login_type,admin.type_id
    @order = []
    @order = VendorPortal::VendorPortalCrud.unaccepted_orders(doc,login_type,type_id)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@order[0].xmlcol))+'</encoded>'
  end
  
  def acknowledge_po
    doc = Hpricot::XML(request.raw_post)
    @error = VendorPortal::VendorPortalCrud.acknowledge_po(doc)
    respond_to do |format|
      format.xml do  
        render :template => "purchase/vendor_portal/errorlog"
      end 
    end
  end
  
  def accept_po
    doc = Hpricot::XML(request.raw_post)
    @error = VendorPortal::VendorPortalCrud.accept_po(doc)
    respond_to do |format|
      format.xml do  
        render :template => "purchase/vendor_portal/errorlog" 
      end 
    end
  end   
end
