class DefaultAdminUi < ActiveRecord::Base
  def self.left(options)
    DefaultAdminUi.find(:all, :conditions => {:owner => options[:owner], :container => "left", :admin_user_id => options[:admin_id]}, :order => "position ASC")
  end
  
  def self.middle(options)
    DefaultAdminUi.find(:all, :conditions => {:owner => options[:owner], :container => "middle", :admin_user_id => options[:admin_id]}, :order => "position ASC")
  end
  
  def self.right(options)
    DefaultAdminUi.find(:all, :conditions => {:owner => options[:owner], :container => "right", :admin_user_id => options[:admin_id]}, :order => "position ASC")
  end  
end
