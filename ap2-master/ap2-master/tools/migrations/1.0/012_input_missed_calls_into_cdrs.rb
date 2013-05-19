f = File.open("/tmp/missed_calls.csv")
f.each do |line|
  data = line.split(",")
  if data.size == 3
    #puts "#{data[0]} Dst:#{data[1]} Duration:#{data[2]}"
    match_cdr = Cdr.find_all_by_dst_number(data[1])
    match_cdr = match_cdr[-1]
    if match_cdr
      puts "Found match for #{data[1]}"
    else
      puts "Could not find match for #{data[1]}"
    end
    cdr = match_cdr.clone
    cdr.date = data[0]
    cdr.duration = data[2]
    cdr.rate = nil
    cdr.cost = nil
		cdr.session_log = nil
		cdr.uniqueid = nil
		cdr.feedback_id = nil
    cdr.disposition = "ANSWER"
    cdr.save
  else
    puts "Another Carrier"
  end
end
