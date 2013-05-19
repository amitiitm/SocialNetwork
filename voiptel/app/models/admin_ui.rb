class AdminUi < ActiveRecord::Base
  belongs_to :default_ui
  belongs_to :admin_user
  
  named_scope :owner, lambda { |owner| 
    { :conditions => {:owner => owner} }
  }
  
  named_scope :container, lambda { |container|  
    { :conditions => {:container => container}, :order => "position ASC" }
  }
  
end
