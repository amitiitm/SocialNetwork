class Admin::Moodule < ActiveRecord::Base
  require 'has_finder'
  include UserStamp
  include Dbobject
  
  has_many:role_permissions
  has_many :menus, :conditions => { :trans_flag => 'A' }
  scope :activemoodules, :conditions => { :trans_flag => 'A' }

end
