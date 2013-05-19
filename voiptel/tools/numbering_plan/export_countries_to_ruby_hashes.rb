# Bugy code
def line(c)
  l =  "%#{c.country_code}% => {:name => %#{c.name}%, :special_case => #{c.special_case ? 'true' : 'false'}, :country_name_2_letters => %#{c.country_name_2_letters}%, :country_name_3_letters => %#{c.country_name_3_letters}%, :min_cns => #{c.min_cns}, :max_cns => #{c.max_cns}},"
  l.gsub("%", "\"")
end

for c in Country.find(:all, :order => "country_code ASC")
  if not c.special_case
   puts line(c)
  else
    if c.is_parent_country
      puts line(c)
    end
  end
end