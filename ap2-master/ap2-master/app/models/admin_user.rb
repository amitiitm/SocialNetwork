require 'digest/sha1'

class AdminUser < ActiveRecord::Base
  attr_accessor :new_password
  attr_accessor :custom_default_date_format
  has_many :credits
  has_many :follow_ups
  has_many :admin_uis
  has_many :assigned_memos, :class_name => "Memo", :foreign_key => "assigned_to_id"
  has_many :created_memos, :class_name => "Memo", :foreign_key => "created_by_id"
  has_many :followups, :class_name => "Memo", :foreign_key => "followup_by_id"
  has_many :admin_users
  has_many :leads
  has_many :pbx_cdrs
  has_many :tmp_credit_card_infos
  has_many :sign_ups, :as => :signed_up_by, :class_name => "Account"
  
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  before_validation :set_confirmation_password
  after_create  :set_default_uis

  validates_presence_of     :default_date_format
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :case_sensitive => false
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message,
                            :unless => :email_blank?

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :new_password, :ext, :default_date_format, :custom_default_date_format
  before_validation :set_new_password
  before_validation :set_custom_date_if_any
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  
  def set_custom_date_if_any
    unless self.custom_default_date_format.blank?
      self.default_date_format = self.custom_default_date_format
    else
      logger.info { "------------ FUCKING EMPTY!" }
    end
    logger.info { "-------- SELF: #{self.default_date_format} custom: #{custom_default_date_format}" }
  end
  
  def bname
    self.name.split(" ").join("_")
  end
  
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def email_blank?
    self.email.blank?
  end
  
  private
  def set_confirmation_password
    self.password_confirmation = self.password
  end
  
  def set_default_uis
    AdminUi.find(:all, :conditions => {:admin_user_id => 2}).each do |template|
      ui = template.clone
      ui.admin_user_id = self.id
      ui.save
    end
  end
  
  def self.find(*args)    
    options = args.extract_options!
    if options[:conditions]
      if options[:conditions][:id]
        if options[:conditions][:id].to_i == 0
          return AP.new
        end
      end
    end
    if args[0].class == String
      return AP.new if args[0] == "0"
    else
      return AP.new if args[0] == 0
    end
    validate_find_options(options)
    set_readonly_option!(options)

    case args.first
      when :first then find_initial(options)
      when :last  then find_last(options)
      when :all   then find_every(options)
      else             find_from_ids(args, options)
    end
  end
  
  def self.select_options(options = {:include_system => true})
    if options[:include_system]
      [["System", "0"]] + AdminUser.all.collect {|au| [au.name, au.id.to_s]}
    else
      AdminUser.all.collect {|au| [au.name, au.id.to_s]}
    end
  end
  
  def self.select_options_for_date_format
    time = Time.now
    [
      [time.strftime("%a %m/%d %H:%M"), "%a %m/%d %H:%M"],
      [time.strftime("%a %m-%d %H:%M"), "%a %m-%d %H:%M"],
      [time.strftime("%a %m/%d/%y %H:%M"), "%a %m/%d/%y %H:%M"],
      [time.strftime("%a %m-%d-%y %H:%M"), "%a %m-%d-%y %H:%M"],
      [time.strftime("%a %m/%d/%Y %H:%M"), "%a %m/%d/%Y %H:%M"],
      [time.strftime("%a %m-%d-%Y %H:%M"), "%a %m-%d-%Y %H:%M"],
      [time.strftime("%m/%d %H:%M"),    "%m/%d %H:%M"],
      [time.strftime("%m-%d %H:%M"),    "%m-%d %H:%M"],
      [time.strftime("%m/%d/%y %H:%M"), "%m/%d/%y %H:%M"],
      [time.strftime("%m-%d-%y %H:%M"), "%m-%d-%y %H:%M"],
      [time.strftime("%m/%d/%Y %H:%M"), "%m/%d/%Y %H:%M"],
      [time.strftime("%m-%d-%Y %H:%M"), "%m-%d-%Y %H:%M"],
      ["Custom", "custom"]
    ]
  end
  
  private
  def set_new_password
    if not self.new_password.blank?
      self.password = self.new_password
      self.password_confirmation = self.new_password
    end
  end
  
  protected
end
