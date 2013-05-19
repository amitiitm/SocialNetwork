require 'digest/sha1'
class Main::MainUser < ActiveRecord::Base
  establish_connection  'main_schema'
  include UserStamp
  include Dbobject
  cattr_accessor :current_user  
#  
  # Virtual attribute for the unencrypted password
  attr_accessor :password
#  belongs_to :main_company
  
  #   :my_assets, :class_name => 'Asset', :conditions => 'user_id = #{id}'
  
  validates     :login, :email,:presence => true
  validates     :password, :presence => true,                  :if => :password_required?
  validates     :password_confirmation,:presence => true,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  #validates_length_of       :email,    :within => 3..100, :message => 'Length should be 3 to 100 characters'
  validates_format_of       :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i ,:message=>'not Valid'
  validates_uniqueness_of   :login, :email, :case_sensitive => false ,:message => 'Email id has aleady been taken.. '
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation,:first_name,:last_name,:customer_id,:vendor_id,:login_flag_id,:category_id,
                  :login_type, :type_id, :id

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
#    puts encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
 protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
   
end
