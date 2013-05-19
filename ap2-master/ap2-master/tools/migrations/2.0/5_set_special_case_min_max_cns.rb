for c in Country.find(:all, :conditions => {:special_case => true})
  min_cns = Country.find(:first, :conditions => {:country_code => c.country_code, :special_case => true}, :order => "min_cns asc").min_cns
  max_cns = Country.find(:first, :conditions => {:country_code => c.country_code, :special_case => true}, :order => "max_cns desc").max_cns
  c.smin_cns = min_cns
  c.smax_cns = max_cns
  c.save
end

puts "done!"