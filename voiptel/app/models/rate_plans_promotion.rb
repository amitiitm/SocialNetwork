class RatePlansPromotion < ActiveRecord::Base
  belongs_to :rate_plan
  belongs_to :promotion
end
