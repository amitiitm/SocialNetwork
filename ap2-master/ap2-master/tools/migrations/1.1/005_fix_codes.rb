countries = Hash.new
file = File.open(File.dirname(__FILE__) + "/countries.csv")
file.each do |line|
	unless line.blank?
		line = line.gsub("\n","")
		line = line.gsub("\r","")
		row = line.split(",")
		#puts row
		countries[row[0]] = {:cc => row[1], :name => row[2]}
	end
end
zones = Zone.find(:all)
zones.each do |z|
	puts "#{z.country_id}: #{countries[z.country_id.to_s][:name]} #{countries[z.country_id.to_s][:cc]}"
	match = Country.find(:first, :conditions => {:country_code => countries[z.country_id.to_s][:cc].to_s})
  if match
    if match.special_case
  	 match = Country.find(:first, :conditions => {:country_code => countries[z.country_id.to_s][:cc].to_s, :is_parent_country => true})
  	end
  end
	z.country_id = match.id
	z.save
end

file.close
