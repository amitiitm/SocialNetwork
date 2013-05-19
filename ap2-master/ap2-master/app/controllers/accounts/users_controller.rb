class Accounts::UsersController < ApplicationController
  layout nil
  def index
    
  end

  def show
  end
  
  def new
    @user = User.new
    @account = Account.find(params[:account_id])
    resp
  end
    
  def edit
    @user = User.find(params[:id])
    @account = Account.find(params[:account_id])
    resp    
  end

  def create
    @user = User.new(params[:user])
    @user.account_id = params[:account_id]
    result = @user.save
    if result
      @error = false
      @user.account.assign_dids
      @user.send_welcome_email
      # Notifier.deliver_new_access_numbers(@user)
    end
    @path = account_overview_index_path(params[:account_id])
    resp result
  end

  def update
    @user = User.find(params[:id])
    result = @user.update_attributes(params[:user])
    if result
      @user.account.assign_dids
      # Notifier.deliver_new_access_numbers(@user)
    end
    @path = account_overview_index_path(params[:account_id])
    resp result
  end

  def destroy
    @user = User.find(:first, :conditions => {:account_id => params[:account_id], :id => params[:id]})
    @user.destroy
    @path = account_overview_index_path(params[:account_id])
  end

end
