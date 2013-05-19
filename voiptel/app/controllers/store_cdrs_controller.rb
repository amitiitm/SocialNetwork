require "cgi"
class StoreCdrsController < ApplicationController
  skip_filter :login_required
  def logger
	end
  
  def create
    render :layout => false
    Rails.logger.info { "uuid: #{params[:uuid]}" }
    Rails.logger.info { CGI::unescape(params[:cdr]) }
  end
  
  def index
    render :layout => false
  end
end
