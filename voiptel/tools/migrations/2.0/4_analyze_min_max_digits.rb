hash = Hash.new
min_subscriber_num = 1000
max_subscriber_num = 0
#NumberingPlan.find_in_batches(:conditions => {:country_name_2_letters => "SE"}) do |batch|
NumberingPlan.find_in_batches() do |batch|
  batch.each do |np|
    #n = np.country_name
    n = "#{np.country_name_2_letters}_#{np.country_code}"
    
    if not hash[n]
      hash[n] = {
        :country_code => np.country_code,
        :country_name_2_letters => np.country_name_2_letters,
        :country_name_3_letters => np.country_name_3_letters,
        :max_cns => 0,
        :min_cns => 1000,
        :max_subscriber_num => 0,
        :min_subscriber_num => 1000
      }
    else
      c = hash[n]
      c[:max_cns] = [c[:max_cns], np.cns.length].max
      
      unless np.cns.length == np.country_code.length
        c[:min_cns] = [c[:min_cns], np.cns.length].min
      end
      
      unless np.area_code_length == 0 and np.min_subscr_nr_length == 0 and np.max_subscr_nr_length == 0
        if np.area_code.length == 0
          min_subscriber_num = np.country_code.length + np.min_subscr_nr_length
          max_subscriber_num = np.country_code.length + np.max_subscr_nr_length
        else
          min_subscriber_num = np.country_code.length + np.area_code_length + np.min_subscr_nr_length
          max_subscriber_num = np.country_code.length + np.area_code_length + np.max_subscr_nr_length
        end
      end
      
      c[:max_subscriber_num] = [c[:max_subscriber_num], max_subscriber_num].max
      c[:min_subscriber_num] = [c[:min_subscriber_num], min_subscriber_num].min
   
    end
  end
end

puts "Country Name,Country Code,2 Letter,3 Letter,Min CNS,Max CNS,Min Digits, Max Digits"
hash.keys.each do |k|
  c = hash[k]
  puts "#{k.gsub(',', ';')}, #{c[:country_code]}, #{c[:country_name_2_letters]}, #{c[:country_name_3_letters]}, #{c[:min_cns]}, #{c[:max_cns]}, #{c[:min_subscriber_num]}, #{c[:max_subscriber_num]}"
  #country = Country.find_by_country_name_2_letters(c[:country_name_2_letters])
  country = Country.find(:first, :conditions => {:country_code => c[:country_code], :country_name_2_letters => c[:country_name_2_letters]})
  unless country
    puts "cannot find #{k} cc: #{c[:country_code]} 2l: #{c[:country_name_2_letters]}"
  end
  country.min_digits = c[:min_subscriber_num]
  country.max_digits = c[:max_subscriber_num]
  country.min_cns = c[:min_cns]
  country.max_cns = c[:max_cns]
  country.save
end