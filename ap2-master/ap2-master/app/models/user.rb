require 'net/http'
require 'uri'

class User < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  has_many :phones, :dependent => :destroy
  has_many :notifications
  has_many :assigned_dids#, :dependent => :destroy
  has_many :cdrs
  has_one :auth_user
  has_many :transaction_references
  has_many :vm_boxes
  has_many :recordings
  has_many :testimonials
  
  has_many :pbx_cdrs, :as => :contactable
  
  #has_many :memos, :as => :contactable
  
  accepts_nested_attributes_for :phones, :allow_destroy => true
  accepts_nested_attributes_for :auth_user, :allow_destroy => true, :reject_if => :all_blank
  
  has_one :address,:dependent => :destroy
  
  belongs_to :account
  
  validates_presence_of :first_name, :message => "First name can't be blank"
  validates_presence_of :last_name,  :message => "Last name can't be blank"
  validates_presence_of :time_zone, :message => "Please select a time zone"
  validates_presence_of :email, :message => "Email can't be blank", :if => :validate_email?
  validates_format_of   :email, :with => /[a-z0-9_-]+(\.[a-z0-9_-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/,
                        :message => "Please enter a valid email address", :if => :validate_email?

  #validates_associated :phones
  before_save :titleize_names
  
  liquid_methods  :first_name, :last_name, :full_name, :account_number,
                  :balance, :phones, :old_balance, :charge_amount,
                  :charge_date, :deposits_in_current_month,
                  :login, :temporary_password, :generate_temporary_password
  
  #after_save :send_welcome_message
  attr_accessor :password, :password_confirmation, :referred, :validate_email
  
  def info
    full_name
  end
  
  def login
    self.auth_user.login
  end
  
  def generate_temporary_password
    self.auth_user.create_tmp_password
  end
  
  def temporary_password
    self.auth_user.tmp_password.password
  end
  
  def to_s
    "user"
  end
  
  def name
    first_name + " " + last_name
  end
  
  def first_name=(name)
    self[:first_name] = name.strip
  end
  
  def last_name=(name)
    self[:last_name] = name.strip
  end
  
  def email=(email)
    self[:email] = email.strip
  end
  
  def deposits_in_current_month
    deposits = self.account.order_transactions.find(:all, :select => "created_at, amount", :conditions => {:status => 1, :created_at => (Time.now.beginning_of_month.utc..Time.now.utc)})
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def charge_date 
    tr = account.order_transactions.find(:last, :conditions => {:status => 1})
    tr.created_at
  end
  
  def account_number
    self.account.number
  end
  
  def charge_amount
    tr = account.order_transactions.find(:last, :conditions => {:status => 1})
    amount = (tr.amount / 100.0)
    number_to_currency(amount)
  end
  
  def old_balance
    tr = account.order_transactions.find(:last, :conditions => {:status => 1})
    old_balance = self.account.balance - (tr.amount / 100)
    number_to_currency(old_balance)
  end
  
  def balance
    number_to_currency(self.account.balance)
  end
  
  def send_welcome_email
     unless self.email.blank?
       v = ActionView::Base.new(Rails::Configuration.new.view_path)
       content = v.render(:partial => "notifier/welcome", :locals => {:account => self.account, :dids => self.assigned_dids, :user => self})
       res = Net::HTTP.post_form(URI.parse('http://api.jangomail.com/api.asmx/SendTransactionalEmail'),
        {
          'Username'        => 'openfo',
          'Password'        => 'Farhad1234',
          'FromEmail'       => 'support@openfo.com',
          'FromName'        => 'OpenFo Network',
          'ToEmailAddress'  => self.email,
          'Subject'         => 'Welcome To OpenFo Calling System',
          'MessagePlain'    => '',
          'MessageHTML'     => content,
          'Options'         => ''
        })
      puts res.body
    end
  end
  
  def send_update_email
     unless self.email.blank?
       puts "Sending email to #{self.name} (#{self.email})"
       Notifier.deliver_update(self,assigned_dids)
    end
  end
  
  def action_id
    if self.new_record?
      "new_user"
    else
      self.id
    end
  end
  
  def create_auth_user
    auth_user = AuthUser.new
    if not self.email.blank?
      auth_user.login = self.email
    else
      p = self.phones.find_by_phone_type(Phone::MOBILE) || self.phones.first
      if p
        auth_user.login = self.first_name + p.phone_number[p.phone_number.length-4..-1]
      end
    end
    auth_user.create_tmp_password
    unless auth_user.valid?
      if auth_user.errors.on(:login)
        p = self.phones.find_by_phone_type(Phone::MOBILE) || self.phones.first
        if p
          auth_user.login = self.first_name + p.phone_number[p.phone_number.length-4..-1]
        end
      end
    end
    if auth_user.valid?
      self.auth_user = auth_user
      self.auth_user.save
    end
  end
  
  def account_holder?
    self.account.account_holder_id == self.id
  end
  
  
  private
  
  def titleize_names
    self.first_name = ActiveSupport::Inflector.titleize(self.first_name)
    self.last_name = ActiveSupport::Inflector.titleize(self.last_name)
  end
  def validate_email?
    self.validate_email
  end
  
  def use_password?
    !self.password.blank? and !self.password_confirmation.blank?
  end  
end
