for d in Did.all
  area_code_info = AreaCodeInfo.find(:first, :conditions => {:npanxx => d.number[1..6]})
  if area_code_info
    d.rate_center = area_code_info.ratecenter
    d.lata = area_code_info.lata
    d.lat = area_code_info.lat
    d.long = area_code_info.long
    d.save
  end
end