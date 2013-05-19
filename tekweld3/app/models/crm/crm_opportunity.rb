class Crm::CrmOpportunity < ActiveRecord::Base
include UserStamp
include Dbobject
include GenericSelects

belongs_to :crm_account
has_one :crm_activity

validates_numericality_of  :probability_per, :less_than_or_equal_to=>999.99,:allow_nil=>true 
validates_numericality_of  :amount, :less_than_or_equal_to=>999999999.99,:allow_nil=>true 
end
