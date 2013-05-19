class Payment::CustomerPaymentProfile < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
end
