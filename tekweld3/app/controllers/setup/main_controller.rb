class Setup::MainController < ApplicationController
  require 'hpricot'
  include Connectionschema
  skip_before_filter :select_db

  # This function has been written for our use to drop the schema. Not being called from the application
  def drop_schema()
    Main::MainUserCrud.drop_schema("DEMO1087")
    render :text => 'Success!!!!!!!!!'
  end

  def create_main_user
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    Connectionschema.establish_connection_schema('main')
    @main_user = Main::MainUserCrud.create_user(doc)
    if @main_user.errors.empty?
      self.current_user = @main_user
      respond_to do |format|
        format.xml
      end
    else
      respond_to do |format|
        format.xml  {render :xml => @main_user.errors.to_xml() }
      end
    end
  end

  def create_main_company
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    @main_company = Main::MainUserCrud.create_company(doc)
    if @main_company.errors.empty?
      session[:schema] = @main_company.schema_name
      respond_to do |format|
        format.xml
      end
    else
      respond_to do |format|
        format.xml  {render :xml => @main_company.errors.to_xml() }
      end
    end
  end

  def main_user_login
    Connectionschema.establish_connection_schema('main')
    @error = []
    login = params[:login]
    password = params[:password]
    #  code = params[:code]
    request_array = (request.host).split(".")
    if request_array[1] != 'promo'
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
      return
    end
    code = request_array[0]
    remember_me = params[:remember_me]
    begin
      #    if session[:schema] or  session[:user_id]
      raise if active_session?
      #    end
      company =  Main::MainCompany.find_by_code(code)
      if !company
        render_error('This Company does not exist!!!')
      else
        authenticate_main_user(login,password)
        schema_name=Main::MainCompany.find_by_sql ["select DB_ID ('#{company.schema_name}') as flag"]  #newly added to check database existence
        if schema_name[0].flag  #newly added to check database existence
          if Connectionschema.establish_connection_schema(company.schema_name)
            authenticate_schema_user(login,password,remember_me)
          else
            self.current_user = :false
          end
        else
          render_error('This Company does not exist!!!')  #newly added to check database existence
          return  #newly added to check database existence
        end
        if logged_in?
          session[:schema] = company.schema_name
          #        Admin::UserCrud.update_successful_logins(self.current_user)
          #        render :xml => self.current_user.to_xml
          @main_user = self.current_user
          @company_list = Admin::UserCrud.company_list(self.current_user.default_company_id)[0]
          respond_to do |format|
            format.xml
          end
        else
          render_error('Login/Password wrong!!')
        end
      end
    rescue Exception
      render_error('Session could not be created, or last session was not properly closed. Please close your browser and try login again.')
      #    render :text => "badsession"  Need to uncomment this
    end
  end

  def render_error(error)
    @error << error
    render  :template => "setup/main/errorlog"
    reset_session
  end

  def destroy
    Connectionschema.establish_connection_schema(session[:schema])
    #    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/login')
  end

end
