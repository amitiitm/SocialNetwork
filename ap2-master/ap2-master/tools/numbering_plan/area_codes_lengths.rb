hash = Hash.new
NumberingPlan.find_in_batches() do |batches|
  batches.each do |np|
    unless hash[np.area_code.length]
      hash[np.area_code.length] = true
      puts np.area_code.length
    end
  end
end