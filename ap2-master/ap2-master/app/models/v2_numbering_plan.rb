class V2NumberingPlan < ActiveRecord::Base
  belongs_to :country
  belongs_to :country, :class_name => "V2Country"
end
