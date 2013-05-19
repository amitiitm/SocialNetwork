file = File.open(File.dirname(__FILE__) + "/countries.csv")
file.each do |line|
	unless line.blank?
		line = line.gsub("\n","")
		line = line.gsub("\r","")
		row = line.split(",")
		#puts row
		z = OldZone.find(row[0].to_i)
		c = Country.find(:first, :conditions => {:country_name_2_letters => row[1]})
		if c
		  z.country = c
		  z.save
	  else
	    puts "Could not find #{row[1]}"
		end
	end
end
file.close
