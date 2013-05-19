# first is job num
# second number of jobs

def range(num, jobs)
  anp = ActiveNumberingPlan.last
  f = NumberingPlan.first.id
  l = NumberingPlan.last.id
  chank = ((l - f) + 1)/jobs
  r1 = f + ((num - 1) * chank) + (num - 1)
  r2 = r1 + chank
  (r1..r2)
end

def log(num, jobs, st)
  et = Time.now
  file = File.new(File.dirname(__FILE__) + "/jobs/j#{num}", "w+")
  file.puts "num: #{num} jobs: #{jobs} start: #{st} end: #{et} sec: #{et - st} | min: #{(et - st) / 60}"
  file.close
end

num = ARGV[0].to_i
jobs = ARGV[1].to_i

ids = range(num, jobs)
st = Time.now
NumberingPlan.find_in_batches(:conditions => {:id => ids}) do |batch|
  batch.each do |np|
    c = Country.find(:first, :conditions => {:country_code => np.country_code, :country_name_2_letters => np.country_name_2_letters})
    if c
      np.country_id = c.id
      np.save
    else      
      puts "#{np.country_name} #{np.country_code} #{np.id}"
      np.destroy
    end
  end
end

log(num, jobs, st)