class Admin::UserCompany < ActiveRecord::Base
 include UserStamp
  include Dbobject
  include General
  include ClassMethods
  
   belongs_to :company, :class_name => 'Setup::Company'
   belongs_to :user, :class_name => 'Admin::User' ,:foreign_key=>'user_id'
   
   def fill_default_detail_values
     
   end
end
