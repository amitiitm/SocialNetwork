class Admin::UserPermission < ActiveRecord::Base
  include Dbobject
  include UserStamp
  require 'has_finder'
  
  belongs_to :user, :class_name => 'User'
  belongs_to:role
  scope :activeuserpermissions, :conditions => { :trans_flag => 'A' }

   def self.get_user_permissions()
     Admin::UserPermission.activeuserpermissions     
    end
    
end
