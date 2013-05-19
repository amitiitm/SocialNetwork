d1 = Chronic.parse("2010-07-11 00:00:00").utc
d2 = Chronic.parse("2010-07-17 23:59:59").utc

carrier = 23

answer = Cdr.count(:conditions => ["date >= ? and date <= ? and disposition = ? and carrier_id = ? and dst_number like ?", d1, d2,'ANSWER',carrier, "989%"])
all = Cdr.count(:conditions => ["date >= ? and date <= ? and carrier_id = ? and dst_number like ?", d1, d2, carrier, "989%"])

duration = Cdr.sum(:duration, :conditions => ["date >= ? and date <= ? and disposition = ? and carrier_id = ? and dst_number like ?", d1, d2,'ANSWER',carrier, "989%"])

puts "ASR: #{answer.to_f/all}"
puts "ACD: #{duration.to_f/answer}"

puts "Answer: #{answer} All: #{all}"
puts "Duration: #{duration}"
