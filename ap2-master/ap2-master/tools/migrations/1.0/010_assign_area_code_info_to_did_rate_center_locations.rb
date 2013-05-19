for did in Did.all
  if did.area_code_info
    did_rate_center_location = DidRateCenterLocation.find(:first, :conditions =>
    {
      :npa => did.npa_number,
      :lat => did.area_code_info.lat,
      :long => did.area_code_info.long
    })

    if did_rate_center_location
        did.did_rate_center_location = did_rate_center_location
        did.save
    else #did_rate_center_location
        area_code_info = AreaCodeInfo.find(:first, :conditions => {:npanxx => did.npanxx_number})
      if area_code_info
        did_rate_center_location = DidRateCenterLocation.new()
        did_rate_center_location.area_code_info = area_code_info
        did_rate_center_location.npa = area_code_info.npa
        did_rate_center_location.lat = area_code_info.lat
        did_rate_center_location.long = area_code_info.long
        did_rate_center_location.save
        did.did_rate_center_location = did_rate_center_location
        did.save
      end #area_code_info
    end # did_rate_center_location
  end # did.area_code_info
end #for 