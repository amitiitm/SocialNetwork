xml.instruct! :xml, :version=>"1.0"
if @usps_time_in_transit
  xml.inhand_date(@usps_time_in_transit)
end