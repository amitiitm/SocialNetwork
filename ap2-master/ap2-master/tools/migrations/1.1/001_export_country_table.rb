file = File.new(File.dirname(__FILE__) + "/countries.csv", "w+")
Country.all.each do |c|
  file.puts("#{c.id},#{c.country_code},#{c.name}")
end
file.close