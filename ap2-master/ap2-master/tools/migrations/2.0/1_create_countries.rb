$special_cases = {
  "GI" => {:cc => "350" },
  "QY" => {:cc => "90" },
  "VA" => {:cc => "379" },
  "AQ" => {:cc => "672" },
  "PS" => {:cc => "970" },
  "QN" => {:cc => "374" },
  "QZ" => {:cc => "-1" }  
}

def ignore(cm)
  n = cm.country_name_2_letters
  unless $special_cases[n]
    return false
  end

  if $special_cases[n][:cc] == "-1"
    puts "Ignoring #{cm.country_code} name: #{cm.name} l2: #{cm.country_name_2_letters}"
    return true
  end
  
  if $special_cases[n][:cc] != cm.country_code.to_s
    puts "Ignoring #{cm.country_code} name: #{cm.name} l2: #{cm.country_name_2_letters}"
    return true
  end  
end

cs = NumberingPlan.find(:all, :conditions => {:phone_type => "COU"}, :order => "LENGTH(country_code), country_code asc")

for c in cs
  cm                        = Country.new
  cm.id                     = c.country_name_2_letters
  cm.name                   = c.country_name
  cm.country_code           = c.country_code
  cm.country_name_2_letters = c.country_name_2_letters
  cm.country_name_3_letters = c.country_name_3_letters
  cm.publish                = true
  cm.special_case           = false
  next if ignore(cm)
  begin
    cm.save
  rescue Exception => e
    puts "id: #{cm.id} cc: #{cm.country_code} name: #{cm.name}"
  end
  
end

=begin
  special cases
  id: GI cc: 350 name: Gibraltar (correct)
  id: QY cc: 90 name: Cyprus, Turkish
  id: VA cc: 379 name: Vatican City
  id: AQ cc: 672 name: Antarctica
  id: PS cc: 970 name: Palestine
  id: QN cc: 374 name: Nagorno-Karabakh
  id: QZ IGNORE!
=end