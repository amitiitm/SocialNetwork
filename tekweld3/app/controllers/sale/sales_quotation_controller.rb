class Sale::SalesQuotationController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_quotations
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @quotations = Quotation::SalesQuotationCrud.list_quotations(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@quotations[0].xmlcol))+'</encoded>'
  end

  def create_quotations
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @quotations = Quotation::SalesQuotationCrud.create_quotations(doc)
    quotation =  @quotations.first if !@quotations.empty?
    if quotation.errors.empty?
      respond_to_action('show_quotation')
    else
      respond_to_errors(order.errors)
    end
  end

  def show_quotation
    doc = Hpricot::XML(request.raw_post)
    quotation_id  = parse_xml(doc/:params/'id')
    @quotations = Quotation::SalesQuotationCrud.show_quotation(quotation_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def send_quotation_to_customer
    doc = Hpricot::XML(request.raw_post)
    estimate_id  = parse_xml(doc/:params/'id')
    url_with_port = ''
    result,absolute_filename = Quotation::SalesQuotationCrud.generate_sales_estimate_pdf(estimate_id,session[:schema],url_with_port,true)
    if result == true
      render :text => "Estimate Sent Successfully"
    else
      render :text => "#{absolute_filename}-Some Error Occured.Please Contact System Administrator."
    end
  end

  def preview_quotation
    doc = Hpricot::XML(request.raw_post)
    estimate_id  = parse_xml(doc/:params/'id')
    url_with_port = ''
    result,absolute_filename = Quotation::SalesQuotationCrud.generate_sales_estimate_pdf(estimate_id,session[:schema],url_with_port,false)
    if result == true
      filename = absolute_filename.split('/').last
      render :xml =>"<url><result>#{filename}</result></url>"
    else
      render :xml => "<errors><error>#{absolute_filename}</error></errors>"
    end
  end

  #Shipping method for estimation
  def get_shipping_amount_for_quotation
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    shipping_code = parse_xml(doc/:params/'shipping_code')
    if shipping_code == 'UPS'
      response_doc,text = Quotation::SalesQuotationCrud.get_ups_shipping_methods(doc)
      if text == 'error'
        render :xml=>"<errors><error>#{response_doc}</error></errors>"
      else
        @ups_shipping_methods = Hpricot::XML(response_doc)
        response_status_code = parse_xml(@ups_shipping_methods/:RatingServiceSelectionResponse/:Response/'ResponseStatusCode')  if parse_xml(@ups_shipping_methods/:RatingServiceSelectionResponse/:Response/'ResponseStatusCode').first
        rate = parse_xml(@ups_shipping_methods/:RatingServiceSelectionResponse/:RatedShipment/'NegotiatedRates')
        if rate.blank?
          render :xml=>"<errors><error>Negotiated Rates not found. Please Contact System Administrator.</error></errors>"
        elsif(response_status_code.to_i == 1)
          respond_to_action('get_shipping_methods')
        else
          render :xml=>"<errors><error>UPS API ERROR FOUND. Please Contact System Administrator.</error></errors>"
        end
      end
    elsif shipping_code == 'FEDEX'
      @estimated_ship_date = Time.now.to_date
      @fedex_shipping_methods,text = Quotation::SalesQuotationCrud.get_fedex_shipping_methods(doc)
      if text == 'error'
        render :xml=>"<errors><error>#{@fedex_shipping_methods}.</error></errors>"
      else
        respond_to_action('get_shipping_methods')
      end
    elsif shipping_code == 'USPS'
      @usps_shipping_methods,@usps_method_rates,@inhand_dates,text = Quotation::SalesQuotationCrud.get_usps_shipping_methods(doc)
      if text == 'error'
        render :xml=>"<errors><error>#{@inhand_dates}.</error></errors>"
      else
        respond_to_action('get_shipping_methods')
      end
    else
      render :xml=>"<errors><error>No Methods Available For #{shipping_code}</error></errors>"
    end
  end

  def list_estimates_for_sales_order
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @quotations = Quotation::SalesQuotationCrud.list_estimates_for_sales_order(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@quotations[0].xmlcol))+'</encoded>'
  end

end
