class Admin::Document < ActiveRecord::Base 
  require 'has_finder'
  include UserStamp
  include Dbobject
  
  has_many:user_preferences
  has_many:role_permissions
  has_many:user_permission, :through=>:role_permissions
  has_many:menus ,:conditions => { :trans_flag => 'A' }
  scope :activedocuments, :conditions => { :trans_flag => 'A' }
  
  validate(:on => :create) do
    errors[:base] << ("Document " + self.code + " is duplicate..") if Admin::Document.find_by_code(self.code)
  end

end
