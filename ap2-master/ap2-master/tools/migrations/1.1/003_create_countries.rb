hash = Hash.new

def min(var1, var2)
  if var1 < var2
    return var1
  else
    return var2
  end
end

def max()
  
end

NumberingPlan.find_in_batches() do |batch|
  batch.each do |np|
    n = np.country_name
    
    if not hash[n]
      hash[n] = {
        :country_code => np.country_code,
        :country_name_2_letters => np.country_name_2_letters,
        :country_name_3_letters => np.country_name_3_letters,
        :max_cns => 0,
        :min_cns => 1000,
        :max_subscriber_num => 0,
        :min_subscriber_num => 1000,
        :special_case => false
      }
    else
      c = hash[n]
      c[:max_cns] = [c[:max_cns], np.cns.length].max
      
      unless np.cns.length == np.country_code.length
        c[:min_cns] = [c[:min_cns], np.cns.length].min
      end
      
      c[:max_subscriber_num] = [c[:max_subscriber_num], np.max_subscr_nr_length].max
      c[:min_subscriber_num] = [c[:min_subscriber_num], np.min_subscr_nr_length].min          
    end
  end
end
puts "Country Name,Country Code,2 Letter,3 Letter,Min CNS,Max CNS,Min Sub#,Max Sub#"
hash.keys.each do |k|
  c = hash[k]
  puts "#{k.gsub(',', ';')}, #{c[:country_code]}, #{c[:country_name_2_letters]}, #{c[:country_name_3_letters]}, #{c[:min_cns]}, #{c[:max_cns]}, #{c[:min_subscriber_num]}, #{c[:max_subscriber_num]}"
  country = Country.new
  country.name = k.gsub(',', ';')
  country.country_code = c[:country_code]
  country.country_name_2_letters = c[:country_name_2_letters]
  country.country_name_3_letters = c[:country_name_3_letters]
  country.min_cns = c[:min_cns] 
  country.max_cns = c[:max_cns]
  country.publish = true
  country.save
end
