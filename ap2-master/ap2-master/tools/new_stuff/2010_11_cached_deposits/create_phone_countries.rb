def set_phone_countries
  Cdr.find_in_batches(:select => "id, dst_number") do |batch|
    last_cdr = nil
    s = Time.now
		tot = 0
		s2 = 0
    batch.each do |cdr|
      d = Destination.new(cdr.dst_number)
      if d.country
        cdr.country_id = d.country.id
				s2 = Time.now
        cdr.save
				tot += (Time.now - s2)
      end
      last_cdr = cdr
    end
    puts "#{last_cdr.id} #{Time.now - s} #{tot/1000.0}"
  end
end

set_phone_countries
