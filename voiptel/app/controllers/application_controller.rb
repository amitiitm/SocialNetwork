# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #include HoptoadNotifier::Catcher
  helper :all # include all helpers, all the time
  include SslRequirement
  ssl_allowed
  include AuthenticatedSystem
  before_filter :login_required
  before_filter :get_agent
  @header_title = ""
              # See ActionController::RequestForgeryProtection for details
              # Uncomment the :secret if you're not using the cookie session store
              #protect_from_forgery :secret => '7d8d25b22639969faf85d15b3ad8badb'
              #session :session_key => "_openfo_billing_sid"
              # See ActionController::Base for details
              # Uncomment this to filter the contents of submitted sensitive data parameters
              # from your application log (in this case, all fields with names like "password").
              # filter_parameter_logging :password
  filter_parameter_logging :password, :password_confirmation, :old_password, :password_new, :credit_card if RAILS_ENV == "production"

  def debug_http
    env = request.env
    env.keys.each do |k|
      logger.info { "#{k}: #{env[k]}" }
    end
    logger.info { "---------------------------- PARAMS -----------------" }
    params.keys.each do |k|
      logger.info { "#{k}: #{params[k]}" }
    end
  end

  private

  def allowed?
    self.current_admin_user.id <= 2
  end

  def get_agent
    user_agent = request.env['HTTP_USER_AGENT']
    %w{firefox chrome safari msie}.each do |ua|
      if /#{ua}/i === user_agent
        @agent = ua
        return
      end
    end
    @agent = nil
  end

  def process_errors(object, errors)
    errors_hash = Hash.new
    errors_hash[object.to_s] = object.errors.each { |atr, msg|}
    errors.merge(errors_hash)
  end

  def login_required
    if (!session[:admin_user_id])
      redirect_to '/login'
    end
  end

  def resp(success = true)
    respond_to do |format|
      format.html
      format.js { render :layout => false, :status => ((success) ? 200 : 406) }
    end
  end

  def has_pager(model, filter_options = {}, limit = 0, include = nil)
    @page = params[:page].to_i
    @sort = params[:sort]
    @sort_order = params[:sort_order]
    @limit = limit
    limit_param = params[:limit].to_i

    if limit_param > 0
      @limit = limit_param
    end

    if @limit == 0
      @limit = 50
    end

    if @page > 1
      start = (@page - 1) * @limit
    else
      @page = 1
      start = 0
    end

    if filter_options.class == String
      conditions = model.merge_conditions(filter_options, params[:filter])
    else
      conditions = filter_options || {}
      if params[:filter]
        conditions = conditions.merge(params[:filter])
      end
    end

    @size = model.count(:include => include, :conditions => conditions)
    @pages = (@size / @limit) + ((@size % @limit == 0) ? 0 : 1)
    @conditions = conditions
    @params_filter = params[:filter] || {}
    @start = start
  end


  def has_advanced_pager(model, options = {})
    unless options[:limit]
      options[:limit] = 50
    end
    unless options[:filter_options]
      options[:filter_options] = {}
    end
    filter_options = options[:filter_options]

    if not @filter
      @filter = FormFilter.new(model, params[:form_filter])
    end

    @filter_conditions = @filter.conditions

    @page = params[:page].to_i
    @limit = options[:limit]

    limit_param = params[:limit].to_i

    if limit_param > 0
      @limit = limit_param
    end

    if @page > 1
      @start = (@page - 1) * @limit
    else
      @page = 1
      @start = 0
    end

    sql_conditions = ""
    conditions = []

    table = model.table_name
    if options[:filter_options]
      filter_options.keys.each do |k|
        conditions << "#{table}.#{k} = '#{filter_options[k]}'"
      end
    end

    if not @filter_conditions.blank?
      conditions = conditions.join(" AND ")
      if not conditions.blank?
        conditions = "#{conditions} AND "
      end
      @sql_conditions = (conditions + @filter_conditions).strip
    else
      @sql_conditions = conditions.join(" AND ").strip
    end

    if options[:method]
      @size = model.send(options[:method].to_s, :conditions => @sql_conditions, :count => true)
    else
      logger.info { "--------- SQL CONDITIONS: #{@sql_conditions}" }
      @size = model.count(:conditions => @sql_conditions)
    end
    @pages = (@size / @limit) + ((@size % @limit == 0) ? 0 : 1)

    @conditions = filter_options
    @params_filter = params[:filter] || {}
  end

end
