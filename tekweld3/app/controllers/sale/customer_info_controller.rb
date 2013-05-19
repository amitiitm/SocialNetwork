class Sale::CustomerInfoController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def customer_open_memos
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @customers = CustomerInfo::CustomerInfoCrud.customer_open_memos(doc)    
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_memos
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @customers = CustomerInfo::CustomerInfoCrud.customer_memos(doc)  
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_invoice_summary
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @customers = CustomerInfo::CustomerInfoCrud.customer_invoice_summary(doc)       
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_invoice_by_item
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @customers = CustomerInfo::CustomerInfoCrud.customer_invoice_by_item(doc) 
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_credit_invoice_summary
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc) 
    @customers = CustomerInfo::CustomerInfoCrud.customer_credit_invoice_summary(doc)  
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end

  def customer_credit_invoice_by_item
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc) 
    @customers = CustomerInfo::CustomerInfoCrud.customer_credit_invoice_by_item(doc)     
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_open_order
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @customers = CustomerInfo::CustomerInfoCrud.customer_open_order(doc)    
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_orders
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @customers = CustomerInfo::CustomerInfoCrud.customer_orders(doc)    
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def top_sales
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @customers = CustomerInfo::CustomerInfoCrud.top_sales(doc)    
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_open_receipts
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @customers = CustomerInfo::CustomerInfoCrud.customer_open_receipts(doc)    
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_open_credits
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)  
    @customers = CustomerInfo::CustomerInfoCrud.customer_open_credits(doc)    
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_receipts
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @customers = CustomerInfo::CustomerInfoCrud.customer_receipts(doc)    
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_credits
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @customers = CustomerInfo::CustomerInfoCrud.customer_credits(doc)    
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
  def customer_aging
    doc = Hpricot::XML(request.raw_post) 
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)   
    @customers = CustomerInfo::CustomerInfoCrud.customer_aging(doc)    
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@customers[0]['xmlcol']))+'</encoded>'
  end
  
end
