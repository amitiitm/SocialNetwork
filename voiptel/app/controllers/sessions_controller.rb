# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
#  ssl_required  :new if RAILS_ENV == "production"
  skip_before_filter :login_required
  # Be sure to include AuthenticationSystem in Application Controller instead
  layout 'home'

  # render new.rhtml
  def new
    render :action=>'new',:layout => 'home'
  end

  def create
    logout_keeping_session!
    admin_user = AdminUser.authenticate(params[:login], params[:password])
    # if admin_user.login != "mammadiin"
    #   flash[:notice] = "not authorized"
    #   admin_user = nil
    # end
  puts admin_user.inspect  
    if admin_user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_admin_user = admin_user
      session[:user] = admin_user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      #redirect_back_or_default('/')
      redirect_to(root_path)
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin     
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new' ,:layout => 'home'
    end
  end

  def destroy
    logout_killing_session!
    redirect_to '/login'
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn { "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}" }
  end
end
