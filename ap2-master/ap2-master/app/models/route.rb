class Route < ActiveRecord::Base
  belongs_to :carrier
  belongs_to :zone
end
