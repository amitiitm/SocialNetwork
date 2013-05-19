class Setup::UserController < ApplicationController
  #  include ContentModelMethods
  #  include ClassMethods 
  require 'hpricot'
  include General
  include ClassMethods 
 
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = Admin::UserCrud.create(params[:user])  if params[:user]
    #  @user = Admin::User.new(params[:user])
    #  @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def create_xml 
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @user = Admin::UserCrud.create_user(doc)
    if @user.errors.empty?
      self.current_user = @user
      respond_to do |format|
        format.html
        format.xml 
      end  
    else
      respond_to do |format|
        format.xml  {render :xml => @user.errors.to_xml() }
      end
    end
  end


  def update
    doc = Hpricot::XML(request.raw_post)
    @user = Admin::UserCrud.update_user(doc)
    if @user.errors.empty?
      self.current_user = @user
      render :text=> "User Updated Successfully"
    else
      respond_to do |format|
        format.xml  {render :xml => @user.errors.to_xml() }
      end
    end
  end

  def save_preference
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @userpreference = Admin::UserPreferenceCrud.save_preference(doc)
    if @userpreference.errors.empty?
      render :text=> "Successfully updated"
    else
      respond_to do |format|
        format.xml  { render :xml => @userpreference.errors.to_xml() }
      end
    end
  end

  def get_preference
    doc = Hpricot::XML(request.raw_post)
    @userpreference = Admin::UserPreferenceCrud.find_userpreference(doc) 

    #    @userpreference = Admin::UserPreference.find_userpreference(doc) 
    respond_to do |wants|
      wants.html
      wants.xml
    end
  end

  def users_list  
    doc = Hpricot::XML(request.raw_post) 
    @users = Admin::UserCrud.users_list(doc)
    respond_to do |format|
      format.html
      format.xml  
    end  
  end

  def company_list
    @company_list = Admin::UserCrud.company_list
    respond_to do |wants|
      wants.xml { render :xml =>  @company_list.to_xml() }
    end
  end

  def list_users_roles
    @users_roles = Admin::UserPermissionCrud.list_users_roles
  end

  def list_user_roles
    doc = Hpricot::XML(request.raw_post)
    @user_roles = Admin::UserPermissionCrud.list_user_roles(doc)
  end

  def update_user_last_moodule 
    doc = Hpricot::XML(request.raw_post)
    @user = Admin::UserCrud.update_user_last_moodule(doc)
    render :text=>"success"
  end 

  def change_password
    doc = Hpricot::XML(request.raw_post)
    @user = Admin::UserCrud.change_password(doc)
    if @user.errors.empty?
      render :text=> "Password changed."
    else
      respond_to do |format|
        format.xml  { render :xml => @user.errors.to_xml() }
      end
    end
  end

  def reset_password
    doc = Hpricot::XML(request.raw_post)
    login =  parse_xml(doc/'login') if (doc/'login').first  
    code= (request.host).split(".").first  
    Connectionschema.establish_connection_schema('main')
    company =  Main::MainCompany.find_by_code(code)
    if !company
      #        render_error('This Company does not exist!!!')
      @error=[]
      @error << 'This Company does not exist!!!'
      render :xml=> @error , :template => "setup/main/errorlog.rxml" 
      reset_session
    else
      Connectionschema.establish_connection_schema(company.schema_name)
      user = Admin::User.find_by_login(login)  if login
      if !user
        @error=[]
        @error << 'This User does not exist!!!'
        render :xml=> @error, :template => "setup/main/errorlog.rxml" 
        reset_session
      else
        @user = Admin::UserCrud.reset_password(doc)
        if @user.errors.empty?
          render :text=> "Password has been reset. You will receive new password via email."
        else
          respond_to do |format|
            format.xml  { render :xml => @user.errors.to_xml() }
          end
        end
      end
    end     
  end

  def create_users
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @users = Admin::UserCrud.create_users(doc)
    user =  @users.first if !@users.empty?
    if user.errors.empty?
      respond_to_action("create_users") 
    else
      respond_to_errors(user.errors)
    end  
  end

  def list_users
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @user_list = Admin::UserCrud.list_users(doc)
    render_view(@user_list,"users","L")
  end

  def show_user
    doc = Hpricot::XML(request.raw_post)
    id=parse_xml(doc/:params/'id')
    @users = Admin::UserCrud.show_user(id)
    respond_to_action("create_users")
  end

  def create_user_permissions
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @user_permission = Admin::UserPermissionCrud.create_user_permissions(doc)
    user_permission =  @user_permission.first if !@user_permission.empty?
    if user_permission.errors.empty?
      respond_to_action("create_user_permissions") 
    else
      respond_to_errors(user_permission.errors)
    end
  end

end
