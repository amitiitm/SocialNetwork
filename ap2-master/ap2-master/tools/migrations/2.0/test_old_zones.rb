zones = YAML::load(File.open(File.dirname(__FILE__) + "/routes.yaml"))
for z in zones
  puts "prefix: #{z['prefix']} cc: #{z['country']}"
  puts "\troutes:"
  for r in z["routes"]
    puts "\t\ttrunk: #{r['trunk']} prio: #{r['priority']}"
  end
  puts "--------"
end