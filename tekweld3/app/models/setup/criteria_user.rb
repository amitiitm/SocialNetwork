class Setup::CriteriaUser < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include General
  
   belongs_to :criteria, :class_name => 'Setup::Criteria'
#   validates_presence_of :criteria_id
end
