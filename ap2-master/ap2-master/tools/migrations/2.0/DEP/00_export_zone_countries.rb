file = File.new(File.dirname(__FILE__) + "/countries.csv", "w+")
for z in OldZone.all
  file.puts "#{z.id},#{z.country.country_name_2_letters}"
end
file.close