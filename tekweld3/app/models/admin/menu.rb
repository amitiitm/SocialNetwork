class Admin::Menu < ActiveRecord::Base  
  require 'has_finder'
  include UserStamp
  include Dbobject
  
  belongs_to :document
  belongs_to :moodule
  has_many :role_permissions
  has_many :sub_menus, :class_name => "Admin::Menu", :foreign_key => 'menu_id', :conditions =>  { :trans_flag => 'A' }
  scope :activemenu, :conditions => { :trans_flag => 'A' }
  scope :submenus, :conditions => { :menu_type => 'S',:trans_flag => 'A' }
  
 
end
