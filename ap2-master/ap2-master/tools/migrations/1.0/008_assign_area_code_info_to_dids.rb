for did in Did.all
  area_code_info = AreaCodeInfo.find(:first, :conditions => {:npanxx => did.npanxx_number.to_i})
  did.area_code_info = area_code_info
  did.save
end