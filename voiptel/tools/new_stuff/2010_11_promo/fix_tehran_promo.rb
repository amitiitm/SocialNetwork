d1 = Chronic.parse("2010-09-25").beginning_of_day.utc
d2 = Chronic.parse("2010-11-03").end_of_day.utc

c = 0
for a in Account.find(:all, :conditions => ["created_at >= ? and created_at <= ?", d1, d2])
  c += 1
  puts "#{c}) Acc: #{a.number}: #{a.name}"
  promo = a.promotions[0]
  promo.name = "Tehran 4.9"
  promo.rate = 0.049
  promo.save
end