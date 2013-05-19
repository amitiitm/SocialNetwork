class Rate < ActiveRecord::Base
  belongs_to :country
  belongs_to :trunk
  belongs_to :carrier
  belongs_to :rate_sheet
  
end
