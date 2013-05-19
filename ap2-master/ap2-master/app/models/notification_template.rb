class NotificationTemplate < ActiveRecord::Base
  attr_accessor :new_category, :mtypes
  attr_accessor :parsed_liquid_template
  
  belongs_to :category, :class_name => "NotificationCategory", :foreign_key => "notification_category_id"

  has_one :template_memo_type
  has_many :memo_types, :through => :template_memo_type
  

  validates_presence_of :name, :message => "Name can't be blank"
  validates_presence_of :from_name, :message => "From Name can't be blank"
  validates_presence_of :from_address, :message => "From Address can't be blank"
  validates_presence_of :uid, :message => "Unique Identifier can't be blank"
  validates_uniqueness_of :uid, :message => "Duplicate identifier is not allowed"
  validates_presence_of :notification_category_id, :message => "Category can't be blank"
  
  
  has_one :tmp_template, :class_name => "TmpTemplate"
  
  before_save :update_memo_types
  after_save :destroy_tmp_template
  
  def update_memo_types
    if self.mtypes.class == HashWithIndifferentAccess
      for id in self.mtypes.keys
        checked = self.mtypes[id][:checked]
        checked = (checked == "1") ? true : false
        begin
          memo_type = self.memo_types.find(id)
          if !checked
            memo_type.template_memo_type.delete
          end
        rescue Exception => e
          if checked
            TemplateMemoType.new(:notification_template_id => self.id, :memo_type_id => id).save
          end
        end        
      end
    end
  end
  
  def new_category=(name)
    unless name.blank?
      self.category = NotificationCategory.new(:name => name)
      self.category.save
    end
  end
  
  def liquid_template
    self.parsed_liquid_template ||= Liquid::Template.parse(self.template)
  end
  
  def update_tmp_template(template)
    self.tmp_template ||= TmpTemplate.new
    self.tmp_template.template = template
    self.tmp_template.save
    self.tmp_template
  end
  
  def destroy_tmp_template
    self.tmp_template.delete if self.tmp_template
  end
  
  def send_to_user(user)
    content = self.template
    nt = self
    liquid_template = Liquid::Template.parse(content)
    content = liquid_template.render('user' => user,'faqs' => Faq.all)
    v = ActionView::Base.new(Rails::Configuration.new.view_path)
    content = v.render(:partial => "notification_templates/main_template", :locals => {:content => content, :subject => nt.subject})
    Notifier.deliver_notification("#{nt.from_name} <#{nt.from_address}>", user.email, nt.subject, content)
    
    if user.class == User
      emailable = user.account
    else
      emailable = user
    end
    
    notification = Notification.new(
      :content                    => content,        
      :subject                    => nt.subject,     
      :from_name                  => nt.from_name,   
      :from_address               => nt.from_address,
      :to_name                    => user.full_name, 
      :to_address                 => user.email,
      :notification_template_id   => nt.id,
      :notification_category_id   => nt.category.id,
      :memo_update_id             => nil,
      :delivered                  => true
    )
    
    emailable.notifications     << notification
    nil
  end  
  
  def self.send_notification(memo_update, template_id)
    nt = self.find(template_id)
    content = nt.template
    user = memo_update.memo.memoable.user
    liquid_template = Liquid::Template.parse(content)
    content = liquid_template.render('user' => user,'faqs' => Faq.all)
    v = ActionView::Base.new(Rails::Configuration.new.view_path)
    content = v.render(:partial => "notification_templates/main_template", :locals => {:content => content, :subject => nt.subject})
    Notifier.deliver_notification("#{nt.from_name} <#{nt.from_address}>", user.email, nt.subject, content)
    
    if user.class == User
      emailable = user.account
    else
      emailable = user
    end
    
    notification = Notification.new(
      :content                    => content,        
      :subject                    => nt.subject,     
      :from_name                  => nt.from_name,   
      :from_address               => nt.from_address,
      :to_name                    => user.full_name, 
      :to_address                 => user.email,
      :notification_template_id   => nt.id,
      :notification_category_id   => nt.category.id,
      :memo_update_id             => memo_update.id,
      :delivered                  => true
    )
    
    emailable.notifications     << notification
    memo_update.notifications   << notification
    
    #memo_update = memo.memo_updates.last
    if memo_update.emails.blank?
      memo_update.emails = "#{nt.name}"
    else
      memo_update.emails = "#{memo_update.emails}, #{nt.name}"
    end
    memo_update.save(false)
  end
  
end
