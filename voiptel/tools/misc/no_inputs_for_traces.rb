cdrs = Cdr.find(:all, :conditions => {:disposition => "NOINPUT", :date => Chronic.parse("2009-11-06 00:00:00").beginning_of_day.utc..Chronic.parse("2009-11-14 00:00:00").end_of_day.utc})

for c in cdrs
	cid = c.src[/<(\d+)>/].gsub(/[<>]/,"")
	if c.dst_number == ""
		puts "'#{c.date.to_formatted_s(:db)}',#{cid},#{if c.did then c.did.number else '' end},#{c.id}"
	end
end
