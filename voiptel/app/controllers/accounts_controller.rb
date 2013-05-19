class AccountsController < ApplicationController
  skip_filter :login_required, :only => [:charge]

  def index
    @advance_search = false
    @desc = "Lisft of Open Accounts"
    @header_title = "Open Accounts"
    conditions = "accounts.status=1"
    orders = "created_at desc"
    session[:filter_param] = {}
    if !params[:page].blank? && !session[:search_filter].blank?
      @advance_search = true
      if !params[:sort].blank?
        sort_order = (params[:sort_order] || 'asc')
        orders = "#{params[:sort]} #{sort_order}"
        session[:filter_param][:sort] = params[:sort]
        session[:filter_param][:sort_order] = sort_order
        session[:search_order] = orders
      else
        orders = session[:search_order]
      end
      conditions = session[:search_filter]+"true"
      session[:filter_param][:page] = params[:page]
      session[:filter_param][:limit] = params[:limit]
      session[:filter_param][:size] = params[:size]
    else
      session[:search_filter] = nil
    end
    has_pager(Account, conditions, 25)
    @accounts = Account.find(:all, :conditions => @conditions, :order => orders, :offset => @start, :limit => @limit)
    @path = accounts_path
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  def search
    @advance_search = true
    @search_params = params[:search]
    conditions="accounts.status=1 AND "
    @orders = ""
    if !@search_params.blank?
      session[:search_filter] = nil
      session[:selected_account] = nil
      #Handling the date params
      conditions+= construct_date_query
      #Handling other than date params
      conditions = construct_other_query(conditions)
      #Removing last , in order string
      @orders.gsub!(/\W$/, '')
      session[:search_filter]=conditions
      session[:search_order] = @orders
    elsif !params[:page].blank?
      unless session[:search_filter].blank?
        conditions = session[:search_filter]
        @orders = session[:search_order]
      end
    end
    conditions+="true"
    @header_title = "Open Accounts"
    has_pager(Account, conditions, 25)
    @orders = "created_at desc" if @orders.blank?
    Rails.logger.info "*"*30
    Rails.logger.info @conditions
    Rails.logger.info "*"*30
    @accounts = Account.find(:all, :conditions => @conditions, :order => @orders, :offset => @start, :limit => @limit)
    @path = accounts_path
    respond_to do |format|
      format.html { render :partial => "accounts", :layout => true }
      format.js { render :partial => "accounts", :layout => false }
    end
  end

  def search_result
    @header_title = "Open Accounts"
    conditions = session[:search_filter]+"true"
    order = "created_at desc"
    unless session[:filter_param].blank?
      params[:page]= session[:filter_param][:page]
      params[:limit]= session[:filter_param][:limit]
      params[:size]= session[:filter_param][:size]
      unless session[:filter_param][:sort].blank?
        @advance_search = true
        params[:sort] = session[:filter_param][:sort]
        params[:sort_order] = session[:filter_param][:sort_order]
      end
      order = session[:search_order]
    end
    has_pager(Account, conditions, 25)
    @accounts = Account.find(:all, :conditions => @conditions, :order => order, :offset => @start, :limit => @limit)
    @path = accounts_path
    Rails.logger.info conditions
    respond_to do |format|
      format.html { render :partial => "accounts", :layout => true }
      format.js { render :partial => "accounts", :layout => false }
    end
  end

  def charge
    @account = Account.find(params[:id])
    @result = @account.charge(params[:amount])
    render :layout => false
  end

  def recharge
    @header_title = "Failed Auto Recharge"
    has_pager(Account, "status = 1 AND auto_recharge = 1  AND transaction_references.no_of_failure >=3 AND balance < threshold", 30, [:transaction_references])
    @accounts = Account.find(:all, :include => [:transaction_references], :conditions => @conditions, :order => "accounts.created_at desc", :offset => @start, :limit => @limit)
    @path = recharge_accounts_path
    respond_to do |format|
      format.html
      format.js { render :partial => "failed_auto_recharge", :layout => false }
    end
  end

  def none_paying
    @header_title = "None Paying Accounts"
    has_pager(Account, {:status => 1, :deposits => 0}, 100)

    @accounts = Account.find(:all, :conditions => @conditions, :order => "created_at desc", :offset => @start, :limit => @limit)

    respond_to do |format|
      format.html
      format.js { render :partial => "accounts", :layout => false }
    end

  end

  def closed
    @header_title = "Closed Accounts"
    has_pager(Account, {:status => (2..4)}, 100)

    @accounts = Account.find(:all, :conditions => @conditions, :order => "created_at desc", :offset => @start, :limit => @limit)

    respond_to do |format|
      format.html
      format.js { render :partial => "accounts", :layout => false }
    end
  end


  def show
    split_id = params[:id].split("-")
    if split_id.count > 1
      params[:id] = split_id[1]
    end
    @account = Account.find(params[:id])
    session[:selected_account] = @account.id if (params["action"] == "show" && params["controller"]=="accounts")
    @last_follow_up = @account.follow_ups.last
    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  def overview
    @account = Account.find(params[:id])
    @followup = FollowUp.new
    @last_followup = @account.follow_ups.last
    #@followups = FollowUp.find(:all, :conditions => {:account_id => params[:id]}, :order => "created_at DESC")

    @ui_left = current_admin_user.admin_uis.owner("account_details").container("left")
    @ui_middle = current_admin_user.admin_uis.owner("account_details").container("middle")
    @ui_right = current_admin_user.admin_uis.owner("account_details").container("right")
    @header_title = "Account Details: #{@account.name} (##{@account.number})"
    render :partial => "v2/accounts/ui/account_overview/account_overview", :layout => nil
  end

  def new
    convertable = params[:convertable]
    @account = Account.new
    @account.status = 1
    if convertable
      @model = convertable[:type].camelize.constantize.find(convertable[:id])
      @account.users << @model.user_for_convert
    else
      user = User.new
      user.auth_user = AuthUser.new
      user.phones << Phone.new
      @account.users << user
    end
    resp
  end

  def update
    @account = Account.find(params[:id])
    unless @account.update_attributes(params[:account])
      @error = @account.errors.full_messages
    end
  end

  def create
    @container = params[:container]
    @account = Account.new(params[:account])
    @account.balance = 0
    @errors = false
    result = @account.save
    if result
      @account.signed_up_by_type = "AdminUser"
      @account.signed_up_by_id = session[:user].id
      @account.account_holder_id = @account.users.first.id
      account_number = AccountNumber.first
      @account.number = account_number.number
      account_number.delete
      @account.save
      @account.assign_dids
      @account.account_holder.send_welcome_email
      if @container
        @path = account_path(@account, :compact => "yup", :no_memo => "yup")
      else
        @path = account_path(@account)
      end
    end
    resp(result)
  end

  def construct_date_query
    conditions = ""
    date_columns = ["last_deposit_date", "last_conversation_date", "last_answered_cdr", "created_at"]
    date_columns.each do |value|
      from_date = @search_params["from_" + value]
      to_date = @search_params["to_" + value]
      from = Date.strptime(from_date, '%m-%d-%Y').to_date unless from_date.blank?
      to = (Date.strptime(to_date, '%m-%d-%Y').to_date) unless to_date.blank?
      conditions = generate_date_query(value, to, from, conditions)
    end
    conditions
  end

  def construct_other_query(conditions)
    columns= ["balance", "recharge_amount", "deposits", "last_deposit_amount"]
    columns.each do |value|
      from = @search_params["from_" + value]
      to = @search_params["to_" + value]
      conditions = generate_query(value, to, from, conditions)
    end
    conditions
  end

  def generate_date_query(value, to, from, conditions)
    if to.blank? && from.blank?
    elsif !to.blank? && !from.blank?
      conditions+="DATE(#{value}) between '#{from}' AND '#{to}' AND "
    elsif !to.blank?
      conditions+="DATE(#{value}) <=  '#{to}' AND "
    else
      conditions+="DATE(#{value}) >=  '#{from}' AND "
    end
    @orders += value+' desc,' if !to.blank? or !from.blank?
    conditions
  end


  def generate_query(value, to, from, conditions)
    if to.blank? && from.blank?
    elsif !to.blank? && !from.blank?
      conditions+="#{value} between '#{from}' AND '#{to}' AND "
    elsif !to.blank?
      conditions+="#{value} <=  '#{to}' AND "
    else
      conditions+="#{value} >=  '#{from}' AND "
    end
    @orders += value+' desc,' if !to.blank? or !from.blank?
    conditions
  end
end
