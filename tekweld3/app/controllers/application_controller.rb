class ApplicationController < ActionController::Base
  #  protect_from_forgery
  #  skip_before_filter :verify_authenticity_token

  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  include Connectionschema
  before_filter do |c|
    Admin::User.current_user = c.session[:user_id] unless c.session[:user_id].nil?
  end
  ## added for testing time
  #  before_filter :set_timezone
  #  def set_timezone
  #    Time.zone = current_user.in_time_zone
  #  end
  
  before_filter :format_adjust
  def format_adjust
    request.format = :xml
  end
  after_filter :garbage_collect
  def garbage_collect
    GC.start
  end
  before_filter :select_db
  after_filter :compress_xml
  def compress_xml
    response.body = '<encoded>' + Base64.encode64(Zlib::Deflate.deflate(response.body)) + '</encoded>' if(request.parameters['action'][0..3] == 'show' and response.headers['Content-Type'] == 'application/xml' and response.body[0..8] != '<encoded>')
    return response.body
  end
  def select_db
    #    schema_name = session[:schema]
    #    Connectionschema.establish_connection_schema(schema_name)
    request_array = (request.host).split(".")
    if request_array[1] != 'promo'
      render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
    end

    company_code = request_array[0]
    #    company = Setup::Company.find_by_sql ["select schema_name from main.main_companies where code=?",company_code] if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
    company = Setup::Company.find_by_sql ["select schema_name from main.dbo.main_companies where code=?",company_code] #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
    schema_name = company.first.schema_name
    Connectionschema.establish_connection_schema(schema_name)
  end


  def get_session_variables
    return session[:login_type], session[:type_id]
  end

  def respond_to_action( action_object)
    respond_to do |format|
      format.xml do
        #        render :xml=>xml_object, :action => "#{action_object}"
        render :action => "#{action_object}"
      end
    end
  end

  def respond_to_errors(object_errors)
    respond_to do |format|
      format.xml  { render :xml => object_errors.to_xml() }
    end
  end

  def render_view(view_instance,tag_name,action_type)
    @tag_level1 = tag_name.pluralize
    @tag_level2 = tag_name.singularize
    @view_array = view_instance
    respond_to do |wants|
      wants.xml do
        list_master(action_type) || create_master(action_type)
      end
    end
  end

  def  list_master(action_type)
    #  render :xml=> @view_array , :action => "/generic_view/list_master"   if action_type == 'L'
    #  render :xml=> @view_array , :template => "generic_view/list_master"   if action_type == 'L'
    render :template => "generic_view/list_master"   if action_type == 'L'
  end


  def  create_master(action_type)
    render :template => "generic_view/create_master"   if action_type == 'C'
  end

  #ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  #        :default => "%m/%d/%Y",
  #        :date_time12 => "%m/%d/%Y %I:%M%p",
  #        :date_time24 => "%m/%d/%Y %H:%M"
  #      )

end
