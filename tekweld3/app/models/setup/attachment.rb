class Setup::Attachment < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  
  belongs_to :user , :class_name => 'Admin::User'
end
