d1 = Chronic.parse("2010-09-25").beginning_of_day.utc
d2 = Chronic.parse("2010-11-03").end_of_day.utc

def minutes(seconds)
  if seconds < 60
    0
  else
    (seconds / 60.0).ceil
  end
end
credits = 0
for a in Account.find(:all, :conditions => ["created_at >= ? and created_at <= ?", d1, d2])
  credit = 0
  for c in a.cdrs.find(:all, :conditions => ["dst_number like ? and rate = ?", "9821%", 0.059])
    d = minutes(c.duration)
    c.rate = 0.049
    c.cost = d * 0.049
    c.save
    credit += (d * 0.01)
  end
  if credit > 0
    a.credits << Credit.new(:amount => credit, :admin_user_id => 0, :note => "Tehran promo rate adjustment")
  end
  credits += credit
  puts "Account: #{a.name} credit: #{credit}"
end

puts "Total: #{credits}"