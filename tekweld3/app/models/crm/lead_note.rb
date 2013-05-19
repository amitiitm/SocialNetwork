class Crm::LeadNote < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include ClassMethods
  include GenericSelects
  set_table_name :lead_notes
  
  belongs_to :crm_lead, :class_name => 'Crm::CrmLead'
end
