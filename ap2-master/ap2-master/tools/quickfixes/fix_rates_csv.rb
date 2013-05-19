accounts = Hash.new
for c in Cdr.answered.between(5.days.ago.beginning_of_day.utc..Time.now.utc)
  fix = false
	if c.dst_number.index("98") == 0
		if c.dst_number.index("9821")
			if c.rate != 0.069 and c.rate != 0.059
				#puts "T: #{c.dst_number} rate charge:#{c.rate} d: #{c.duration/60}"
				fix = true
			end
		elsif c.dst_number.index("989")
			# mobile
			if c.rate != 0.139
				#puts "M: #{c.dst_number} rate charge:#{c.rate} d: #{c.duration/60}"
				fix = true
			end
		elsif c.dst_number.index("98")
			# other city
			if c.rate != 0.089
				#puts "C: #{c.dst_number} rate charge:#{c.rate} d: #{c.duration/60}"
				fix = false
			end
		else
			# not iran
		end
		if fix
      unless accounts[c.account_id]
        accounts[c.account_id] = []
      end
      accounts[c.account_id] << c
	  end
	end
end
counter = 0
accounts.keys.each do |id|
	counter += 1
  account = Account.find(id)
  #puts "#{counter}:#{account.name}"
  cdrs = accounts[id]
  for call in cdrs
    puts "#{account.name},#{call.dst_number},#{call.dst_number},#{call.duration/60}:#{call.duration % 60}"
  end
end
