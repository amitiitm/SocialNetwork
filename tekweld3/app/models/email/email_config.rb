class Email::EmailConfig < ActiveRecord::Base
  include UserStamp
  
  has_many :emails
end
