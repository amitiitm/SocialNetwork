xml.instruct! :xml, :version=>"1.0"
if @fedex_inhand_date
  xml.inhand_date(@fedex_inhand_date)
end