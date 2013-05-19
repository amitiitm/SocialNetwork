class RateSheetRevesion < ActiveRecord::Base
  belongs_to :carrier
  belongs_to :rate_sheet
end
