#for d in Did.find(:all, :conditions => {:did_provider_id => 6})
#	no_inputs = Cdr.count(:all, :conditions => {:did_id => d.id, :disposition => "NOINPUT"})
#	puts "#{d.number},#{no_inputs}"
#end
dids = %w{19495964151 17148553150 17029975209}
for d in dids
	puts "reports for #{d}"
	did = Did.find_by_number(d)
	for cdr in Cdr.find(:all, :conditions => {:did_id => did.id, :disposition => "NOINPUT"})
		puts "#{cdr.date.utc.strftime('%Y-%m-%d %H:%M:%S')},#{d},#{cdr.src.gsub(/[<]*[>]*/,'').strip}"
	end
	puts "-------------------------------------"
end
