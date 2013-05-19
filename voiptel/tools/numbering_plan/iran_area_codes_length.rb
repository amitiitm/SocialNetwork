min = 1000
max = 0
NumberingPlan.find_in_batches(:conditions => {:country_code => "98"}) do |batches|
  batches.each do |np|
    if np.area_code_length < min
      min = np.area_code_length
    end
    if np.area_code_length > max
      max = np.area_code_length
    end
  end
end
puts "Min: #{min}"
puts "Max: #{max}"