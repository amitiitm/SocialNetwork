accounts = Hash.new
def duration(seconds)
	minutes = seconds / 60
	if seconds % 60 != 0
		minutes += 1
	end
	minutes
end

def credit_account(amount, note, account)
  account.balance += amount
  account.note = note
  account.admin_user_id = 1
  account.watch_balance_update = true
  account.save
end

for c in Cdr.answered.between(10.days.ago.beginning_of_day.utc..Time.now.utc)
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
      if c.duration > 59
        accounts[c.account_id] << c        
      end
	  end
	end
end
counter = 0
accounts.keys.each do |id|
	counter += 1
  account = Account.find(id)
  puts "#{counter}:#{account.name}"
  cdrs = accounts[id]
  minutes = 0
  for call in cdrs
    #puts "\t#{call.dst_number} r:#{call.rate} d:#{call.billing_minute} - #{call.duration / 60}:#{call.duration % 60}, date: #{call.date}"
    minutes += call.billing_minute
	end
	credit = minutes * 0.02		
	credit_account(credit, "Tehran rate issue", account)
	puts "\t credit: #{credit} minutes: #{minutes} balance: #{account.account_holder.account.balance}"
	user = account.account_holder
	if not user.email.blank?
	 Notifier.deliver_fix_rates(user, cdrs, credit)
	 #puts "\t Emailing: #{user.email}"
	end
end
accounts = Hash.new
def duration(seconds)
	minutes = seconds / 60
	if seconds % 60 != 0
		minutes += 1
	end
	minutes
end

def credit_account(amount, note, account)
  account.balance += amount
  account.note = note
  account.admin_user_id = 1
  account.watch_balance_update = true
  account.save
end

for c in Cdr.answered.between(10.days.ago.beginning_of_day.utc..Time.now.utc)
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
      if c.duration > 59
        accounts[c.account_id] << c        
      end
	  end
	end
end
counter = 0
accounts.keys.each do |id|
	counter += 1
  account = Account.find(id)
  puts "#{counter}:#{account.name}"
  cdrs = accounts[id]
  minutes = 0
  for call in cdrs
    #puts "\t#{call.dst_number} r:#{call.rate} d:#{call.billing_minute} - #{call.duration / 60}:#{call.duration % 60}, date: #{call.date}"
    minutes += call.billing_minute
	end
	credit = minutes * 0.02		
	credit_account(credit, "Tehran rate issue", account)
	puts "\t credit: #{credit} minutes: #{minutes} balance: #{account.account_holder.account.balance}"
	user = account.account_holder
	if not user.email.blank?
	 #Notifier.deliver_fix_rates(user, cdrs, credit)
	 puts "\t Emailing: #{user.email}"
	end
end
