class Setup:: DiscountCouponController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_discount_coupons
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @coupons = Setup::DiscountCouponCrud.list_discount_coupons(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@coupons[0].xmlcol))+'</encoded>'
  end

  def show_discount_coupon
    doc = Hpricot::XML(request.raw_post)
    coupon_id  = parse_xml(doc/:params/'id')
    @coupons = Setup::DiscountCouponCrud.show_discount_coupon(coupon_id)
    respond_to do |wants|
      wants.xml
    end
  end

  def create_discount_coupons
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @coupons = Setup::DiscountCouponCrud.create_discount_coupons(doc)
    coupons =  @coupons.first if !@coupons.empty?
    if  coupons.errors.empty?
      respond_to_action('show_discount_coupon')
    else
      respond_to_errors(coupons.errors)
    end
  end

end
