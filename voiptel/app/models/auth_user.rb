require 'digest/sha1'

class AuthUser < ActiveRecord::Base
  belongs_to :user
  attr_accessor :new_password, :from_admin
  has_one :tmp_password
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
    
  validates_presence_of     :login, :message => "Login can't be blank"
  #validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login, :message => "Your email address is already registered with OpenFo"
  #validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100  
  
  #validates_presence_of     :email
  #validates_length_of       :email,    :within => 6..100, :unless => :email_blank? #r@a.wk, 
  #validates_uniqueness_of   :email
  #validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
                            #:unless => :email_blank?

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :new_password, :from_admin
  before_validation :set_new_password

  def self.random_password(size = 6, first_set = "num", slice = 2)
    chars = (('a'..'z').to_a - %w(i o l ))
    nums  = (2..9).to_a

    password = ""
    next_letter = first_set
    counter = 0

    (1..size).each do |a|
      if next_letter == "char"
        password += chars[rand(chars.size)]
      else
        password += nums[rand(nums.size)].to_s
      end
      counter += 1
      if counter == slice
        counter = 0
        if next_letter == "char"
          next_letter = "num"
        else
          next_letter = "char"
        end
      end
    end
    password  
  end
  
  def create_tmp_password
    if self.tmp_password
      self.tmp_password.delete
    end
    self.tmp_password = TmpPassword.new(:password => AuthUser.random_password)
    self.tmp_password.save
    self.password = tmp_password.password
    self.password_confirmation = tmp_password.password
    self.save
    self.tmp_password.password
  end
  
  def to_s
    "auth_user"
  end
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
    write_attribute :login, (value ? value.downcase : nil)
  end
  
  def make_token
    secure_digest(Time.now, (1..10).map{ rand.to_s })
  end

  protected
  def email_blank?
    email.blank?
  end
  
  def secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end
  private
    
  def set_new_password
    if not self.new_password.blank?
      self.password = self.new_password
      self.password_confirmation = self.new_password
    end
  end
end
