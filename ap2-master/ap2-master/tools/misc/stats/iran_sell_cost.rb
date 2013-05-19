prefix = [
  ["Tehran", "9821"],
  ["Mobile", "989"],
  ["Proper", "98"]
]

def destination(number, prefix)
  prefix.each_index do |i|
    if number.index(prefix[i][1]) == 0
      #puts "#{number}: #{prefix[i][0].to_s}"
      return i
    end
  end
  nil
end

#car = {}
total = 0

DR.new(Time.now.beginning_of_month).upto(Time.now, 1.day) do |d|
  cdrs = Cdr.answer.cc.between(d.date.beginning_of_day.utc..d.date.end_of_day.utc)
  for c in cdrs
    i = destination(c.dst_number, prefix)
    if i
			total += c.cost
    end
  end
end
puts total
=begin
puts "carrier,tehran,mobile,proper"
car.keys.each do |k|
  puts "#{k},#{car[k][0]},#{car[k][1]},#{car[k][2]}"
end
=begin

date = Chronic.parse("2008-08-01 00:00:00")
now = Time.now.utc
d = date

while d < now
  usage = {0 => 0, 1 => 0, 2 => 0}  
  month_start  = d.beginning_of_month.utc
  month_end = d.end_of_month.utc
  #puts "#{month_start}, #{month_end}"
  total_usage = Cdr.sum(:duration, :conditions => ["date > ? and date < ? and disposition = ?", month_start.to_formatted_s(:db), month_end.to_formatted_s(:db), "ANSWER"])
  Cdr.find_in_batches(:conditions => ["date > ? and date < ? and disposition = ?", month_start.to_formatted_s(:db), month_end.to_formatted_s(:db), "ANSWER"]) do |batch|
    batch.each do |cdr|
      zone = destination(cdr.dst_number, prefix)
      if zone
        usage[zone] += cdr.duration
      end
    end
  end
  puts "#{d.strftime('%B %y')},#{usage[0]/60},#{usage[1]/60},#{usage[2]/60},#{total_usage/60}"
  d += 1.month  
end
=end
