def zone(phone)
  country_code = CountryCode.new.country_code(phone)
  country = Country.find(:first, :conditions => {:country_code => country_code})
  if country
    zones = Zone.find(:all, :conditions => {:country_id => country.id}, :order => "prefix_length DESC")
    for zone in zones
      if phone.index(zone.prefix) == 0
        return zone
      end
    end
    return nil
  end
  return nil
end

def duration(seconds)
  min = seconds / 60
  sec = seconds % 60
  if seconds <= 60
    return 0
  else
   return (sec == 0) ? min : (min+1)
  end
end

for cdr in Cdr.all
  unless cdr.zone
    z = zone(cdr.dst_number)
    if z
      cdr.zone = z
      cdr.rate = z.sell_rate
      cdr.cost = duration(cdr.duration) * z.sell_rate
      cdr.save
    end
  else
    cdr.rate = cdr.zone.sell_rate
    cdr.cost = duration(cdr.duration) * cdr.zone.sell_rate
    cdr.save
  end
end
