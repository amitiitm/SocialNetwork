class CarrierTrunk < ActiveRecord::Base
  belongs_to :carrier
  belongs_to :trunk
end
