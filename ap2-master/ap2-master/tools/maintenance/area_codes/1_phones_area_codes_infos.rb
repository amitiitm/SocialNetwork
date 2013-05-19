Phone.all.each do |phone|
  area_code_info = AreaCodeInfo.find(:first, :conditions =>{:npanxx => phone.npanxx.to_i})
  puts "phone: #{phone.complete_phone_number} npanxx: #{phone.npanxx} area_code_info: #{(area_code_info) ? 't' : 'f'}"
  phone.area_code_info = area_code_info
  phone.save_without_validation
end