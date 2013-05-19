class Crm::CrmAccountCategory < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
end
