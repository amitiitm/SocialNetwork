class V2::AccountsController < ApplicationController
  skip_filter :login_required
  layout "admintasia/layout"
  TABS = {
    "details" => 0,
    "billing" => 1,
    "cdr" => 2,
    "follow_up" => 3,
    "stats" => 4,
    "testimonials" => 5,
    "notifications" => 6
  }

  def index
    @header_title = "Open Accounts"
    @accounts = Account.find(:all, :conditions => {:status => 1}, :order => "created_at DESC", :limit => 25)
  end
  
  def list
    @accounts = Account.find(:all, :conditions => {:status => 1}, :order => "created_at DESC", :limit => 20)
  end
  
  def update
    a = Account.new(params[:account])
    logger.info { "#{a.inspect}" }
  end
  
  def show
    @account = Account.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def details   
    if params[:id]
      @account = Account.find(params[:id])
      @header_title = "Account Details: #{@account.name} (##{@account.number})"
      
      @ui_left = current_admin_user.admin_uis.owner("account_details").container("left")
      @ui_middle = current_admin_user.admin_uis.owner("account_details").container("middle")
      @ui_right = current_admin_user.admin_uis.owner("account_details").container("right")
    end
        
    respond_to  do |format|
      format.html
      format.js
    end
                   
  end
  
end
