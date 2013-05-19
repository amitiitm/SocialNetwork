for c in Country.all
  begin
    v2 = V2Country.find(c.country_name_2_letters)
    v2.old_country_id = c.id
    v2.save
  rescue Exception => e    
    puts "Problem with: #{c.country_name_2_letters}"
  end  
end