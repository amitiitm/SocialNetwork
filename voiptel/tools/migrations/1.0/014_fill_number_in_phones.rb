for phone in Phone.all
  phone.number = "#{phone.country_code}#{phone.area_code}#{phone.phone_number}"
  unless phone.save
    puts "Could not save number for phone #{phone.complete_phone_number}"
  end
end