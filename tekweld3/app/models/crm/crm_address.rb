class Crm::CrmAddress < ActiveRecord::Base
include UserStamp
include Dbobject
include GenericSelects  
  
belongs_to :address_for,  :class_name => "CrmAccount",
                      :foreign_key => "address_for_id"
belongs_to :address_for,  :class_name => "CrmContact",
                        :foreign_key => "address_for_id"
end
