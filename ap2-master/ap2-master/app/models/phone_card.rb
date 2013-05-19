class PhoneCard < ActiveRecord::Base
  belongs_to :card
  belongs_to :tmp_phone
end
