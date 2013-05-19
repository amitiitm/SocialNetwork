carriers = V2Country.find(ARGV[0]).rates.find(:all, :select => "distinct carrier_id").each do |cid|
  c = Carrier.find(cid.carrier_id)
  puts "Carrier name: #{c.name}"
  descs = Rate.find(:all, :conditions => {:carrier_id => c.id, :country_id => ARGV[0]}, :select => "distinct carrier_desc")
  for d in descs
    puts " -#{d.carrier_desc}:"
    for r in Rate.find(:all, :conditions => {:carrier_id => c.id, :carrier_desc => d.carrier_desc, :country_id => ARGV[0]})
      puts " #{r.prefix}: #{r.buy.to_s}"
    end
    puts
  end
  puts "----------"  
end