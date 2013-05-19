for d in Did.find(:all, :conditions => {:did_provider_id => 6})
  if d.area_code_info
    if d.area_code_info.state == "CA"
      d.active = false
      d.save
    end
  end
end