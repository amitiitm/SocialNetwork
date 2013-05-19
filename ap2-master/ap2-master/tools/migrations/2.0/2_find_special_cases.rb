puts "Finding duplicate country codes"

cs = Country.all
dup = {}

for c in cs
  unless dup[c.country_code]
    dup[c.country_code] = []
  end
  dup[c.country_code] << c
end

dup.keys.each do |k|
  if dup[k].size > 1
    puts "#{k}:"
    dup[k].each do |i|
      puts "  - #{i.name} #{i.country_code}"
      i.special_case  = true
      i.main = false
      i.save
    end
  end
end

hash = Hash.new
for c in Country.all
  unless hash[c.country_code]
    hash[c.country_code] = {}    
  end
  hash[c.country_code][c.country_name_2_letters] = {:count => NumberingPlan.count(:all, :conditions => {:country_name_2_letters => c.country_name_2_letters}), :name => c.name}
end

hash.keys.each do |k|
  casee = hash[k]
  if casee.keys.size > 1
    #puts "Country Code: #{k}"
    max = 0
    code = ""
    casee.keys.each do |kk|
      country = Country.find(:first, :conditions => {:country_name_2_letters => kk})
      country.special_case = true
      country.save
      #puts "\t#{kk} - #{casee[kk][:name]}: #{casee[kk][:count]}"
      if casee[kk][:count] > max
        max =  casee[kk][:count]
        code = kk
      end
    end
    #puts "\tBIGGGGG: #{code} - #{max}"
    country = Country.find(:first, :conditions => {:country_name_2_letters => code})
    country.is_parent_country = true
    country.save
    id = country.id
    puts "Country: #{country.name} cc: #{country.country_code}"
    casee.keys.each do |kk|
      country = Country.find(:first, :conditions => {:country_name_2_letters => kk})
      country.parent_country_id = id
      country.save
    end    
  end
end