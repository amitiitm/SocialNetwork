class Admin::Role < ActiveRecord::Base
  include UserStamp
  include Dbobject
  require 'has_finder'
  
  has_many:user_permissions
  has_many:role_permissions
  has_many :users, :through => :user_permissions 
  has_many :instance_transitions, :class_name => "Workflow::InstanceTransition"
  scope :activeroles, :conditions => { :trans_flag => 'A' }#, :extend=>ExtendAssosiation

  validate(:on => :create) do
    errors[:base] << ("Role " + self.code + " is duplicate..") if Admin::Role.find_by_code(self.code)
  end

end


