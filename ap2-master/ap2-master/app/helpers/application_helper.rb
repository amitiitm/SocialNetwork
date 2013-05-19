# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  def new_line
    '<br id="new-line" />'
  end

  def mobile_browser?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|iPad|Android)/]
  end
  
  def success(message)
    render(:partial => "ui/success", :locals => {:message => message})
  end
  
  def error_block
    render(:partial => "ui/error")
  end
  
  def yes_no(val, html_class = nil)
    (val)? "Yes" : "No"
  end
  
  def find_type(types, n)
    for t in types
      if t[1] == n
        return t[0]    
      end
    end
    nil
  end
  
  def credit_card_icon(card_type)
    image_tag("billing/#{card_type}.jpg", :class => "icon")
  end
  
  def show_months(first_date)
    names = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]
    links = ""      
    Time.now.year.downto(first_date.year).each do |y|
      counter = 0
      start_month = (first_date.year < y) ? 1 : first_date.month
      end_month = (Time.now.year == y) ? Time.now.month : 12
      links += "<h4 style='padding-bottom:5px'>Year #{y}</h4>"
      (start_month..end_month).each do |m|
        counter += 1
        month = (m < 10) ? "#{m}" : "#{m}"
        links += link_to("#{names[m-1]} #{y}", "?month=#{month}&year=#{y}", :class => "link") + " | "
        if counter == 6
          #links += "<br>"
        end
      end
      links += "<br><br>"
    end
    links
  end
  
  def v2_show_months(first_date)
    names = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]
    links = ""      
    Time.now.year.downto(first_date.year).each do |y|
      counter = 0
      start_month = (first_date.year < y) ? 1 : first_date.month
      end_month = (Time.now.year == y) ? Time.now.month : 12
      links += "<h4 style='padding-bottom:5px'>Year #{y}</h4>"
      (start_month..end_month).each do |m|
        counter += 1
        month = (m < 10) ? "#{m}" : "#{m}"
        links += link_to("#{names[m-1]} #{y}", "month=#{month}&year=#{y}", :class => "months") + " | "
        if counter == 6
          #links += "<br>"
        end
      end
      links += "<br><br>"
    end
    links
  end
  
  def job_update(name)
    j = JobUpdate.find(:first, :conditions => {:key => name})
    return "Last Update: No Info Present" unless j
    return "Last Update: #{time_ago_in_words(j.updated_at, true)} ago"
  end

  def charged_by(ot,tr)
    if ot.charged_type == OrderTransaction::AUTO_RECHARGE
      "Auto Recharge"
    elsif ot.charged_type == OrderTransaction::IVR
      "Phone/IVR"
    elsif ot.charged_type == OrderTransaction::AGENT
      name = AdminUser.find_by_id(ot.charged_by.to_i).name rescue 'Agent'
      ot.charged_by.blank? ? "Openfo Agent" : "Openfo/#{name}"
    elsif !tr.blank? # ot.charged_type == OrderTransaction::CUSTOMER
      tr.user.name + "/Online"
    else
      "--"
    end
  end

  #def version
  #  "v1.0.14"
  #end
  #
  #def version_date
  #  "2012/06/07"
  #end

  def publish_date
    publish_data = YAML::load(File.open("#{RAILS_ROOT}/config/publish.yml"))
    version_date = publish_data["publish"]["date"]
    version = publish_data["publish"]["version"]
    version_date+" "+version
  end

 def recorded_call_url(contable,params)
  key = contable.class.name.downcase+"_id"
  "#{key}=#{params[key]}"

 end
end
