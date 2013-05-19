class PhoneCountry < ActiveRecord::Base
  belongs_to :country, :class_name => "V2Country", :foreign_key => "country_id"
  
  def self.primary_key
    "number"
  end
end
