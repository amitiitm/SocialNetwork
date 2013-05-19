countries = Hash.new
counter = 0

NumberingPlan.find_in_batches() do |batch|
  batch.each do |np|
    if not countries[np.country_name]
      countries[np.country_name] = np.country_code
      puts "#{np.country_name.gsub(',',';')},#{np.country_code},#{np.country_name_2_letters},#{np.country_name_3_letters}"
    end
  end
end