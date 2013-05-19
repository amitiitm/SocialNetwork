class Setup::SessionController < ApplicationController
  #  include ContentModelMethods
  #  include ClassMethods 
  #  require 'hpricot'
  skip_before_filter :select_db
 
  def create
    self.current_user = Admin::User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      render :text => "badlogin"
      #render :action => 'new'
    end
  end

  def create_xml
    self.current_user = Admin::User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = {
          :value => self.current_user.remember_token,
          :expires => self.current_user.remember_token_expires_at
        }
      end
      session[:login_type] = self.current_user.login_type
      session[:type_id] = self.current_user.type_id
      #Thread.current["user"] = self.current_user.id #session[:user_id]                
      render :xml => self.current_user.to_xml 
    else
      render :text => "badlogin"
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/login')
  end

end
