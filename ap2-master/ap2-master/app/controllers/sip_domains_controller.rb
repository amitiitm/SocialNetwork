class SipDomainsController < ApplicationController
  def index
    @sip_domains = SipDomain.all
    resp
  end
  
  def show
    @sip_domain = SipDomain.find(params[:id])
    resp
  end
  
  def new
    @sip_domain = SipDomain.new
    resp
  end
  
  def create
    @sip_domain = SipDomain.new(params[:sip_domain])
    @path = sip_domains_path
    resp @sip_domain.save
  end
  
  def edit
    @sip_domain = SipDomain.find(params[:id])
    resp
  end
  
  def update
    @sip_domain = SipDomain.find(params[:id])
    @path = sip_domains_path
    resp @sip_domain.update_attributes(params[:sip_domain])
  end
  
  def destroy
    @sip_domain = SipDomain.find(params[:id])
    @path = sip_domains_path
    resp @sip_domain.destroy
  end
end
