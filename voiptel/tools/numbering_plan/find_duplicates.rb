h = Hash.new
NumberingPlan.find_in_batches() do |batch|
  batch.each do |np|
    dups = NumberingPlan.find(:all, :conditions => {:cns => np.cns})
    if dups.size > 1
      unless h[np.cns]
        h[np.cns] = true
        puts "#{dups.size} - #{np.country_name}: #{np.cns}"
      end
    end
  end
end