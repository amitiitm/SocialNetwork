V2Country.find(ARGV[0]).rates.find(:all, :order => "prefix_length asc", :include => [:carrier]).each do |r|
  puts "#{r.prefix}: #{r.buy.to_s} - #{r.carrier_desc} (#{r.carrier.name})"
end
