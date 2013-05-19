class Admin::UserPreference < ActiveRecord::Base
  include UserStamp
  include Dbobject
  
  belongs_to:user, :class_name => 'User'
  belongs_to:document
  
end
