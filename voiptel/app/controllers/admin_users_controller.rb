class AdminUsersController < ApplicationController
  #skip_before_filter :login_required

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  def new
    @admin_user = AdminUser.new
    resp
  end
  
  def edit
    @admin_user = AdminUser.find(params[:id])
    resp
  end
  
  def settings
    @admin_user = self.current_admin_user
    resp
  end
  
  def index
    @admin_users = AdminUser.all
    resp
  end

  def update
    @admin_user = AdminUser.find(params[:id])
    @admin_user.update_attributes(params[:admin_user])
    if session[:user].id == @admin_user.id
      session[:user] = @admin_user
    end
  end
  
  def create
    @admin_user = AdminUser.new(params[:admin_user])
    success = @admin_user && @admin_user.save
  end
end
