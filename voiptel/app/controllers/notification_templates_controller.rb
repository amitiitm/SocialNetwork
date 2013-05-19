class NotificationTemplatesController < ApplicationController
  
  def index
    @templates = NotificationTemplate.find(:all, :order => "notification_category_id asc")
    resp
  end
  
  def preview
    if params[:original]
      @t = NotificationTemplate.find(params[:id])
      @t.update_tmp_template(@t.template)
    else
      tmp_template = TmpTemplate.find(params[:id])
      @t = tmp_template.notification_template      
    end
    @content = @t.tmp_template.template
    begin
      template = Liquid::Template.parse(@content)
      @content = template.render('user' => User.first, 'faqs' => Faq.all, 'fax' => Fax.new)
    rescue Exception => e
      @content = e.message
    end
    
    render :layout => false
  end
  
  def destroy
    @notification_template = NotificationTemplate.find(params[:id])
    @path = notification_templates_path
    resp @notification_template.delete
  end
  
  def create_preview
    template = NotificationTemplate.find(params[:id])
    @tmp = template.update_tmp_template(params[:notification_template][:template])
    resp
  end
  
  def send_preview
    template = NotificationTemplate.find(params[:id])
    @tmp = template.update_tmp_template(params[:notification_template][:template])
    params[:notification_template].delete(:template)
    @tmp.notification_template.update_attributes(params[:notification_template])
    
    original = @tmp.notification_template
    
    @content = @tmp.template
    begin
      template = Liquid::Template.parse(@content)
      @content = template.render('user' => User.first,'faqs' => Faq.all)
    rescue Exception => e
      @content = e.message
    end
    
    v = ActionView::Base.new(Rails::Configuration.new.view_path)
    content = v.render(:partial => "notification_templates/main_template", :locals => {:content => @content, :subject => original.subject})
    
    Notifier.deliver_notification("#{original.from_name} <#{original.from_address}>", params[:email], original.subject, content)
    
    resp
  end
  
  def edit
    @notification_template = NotificationTemplate.find(params[:id])
    resp
  end
  
  def update    
    @notification_template = NotificationTemplate.find(params[:id])    
    resp(@notification_template.update_attributes(params[:notification_template]))
  end
  
  def new
    @notification_template = NotificationTemplate.new
    @notification_template.template = 
'{% new_section %}

*Dear %{{user.first_name}}%,*

{% endnew_section %}

{% includes footer %}
'
    resp
  end
  
  def create
    @notification_template = NotificationTemplate.new(params[:notification_template])
    result = @notification_template.save
    if result
      @path = edit_notification_template_path(@notification_template)
    end
    resp(result)
  end
  
end
