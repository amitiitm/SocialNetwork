include ActionView::Helpers::NumberHelper
def stringify_seconds(s)
  s = s.to_i
  hours = (s / 3600)
  s = (s - (hours * 3600))
  minutes = (s / 60)
  seconds = (s % 60)
  "#{hours}:#{minutes}:#{seconds}"
end

f = File.new("/tmp/logs", "w")
f.write "Started @ #{Time.now}\n"
#Cdr.find_in_batches(:batch_size => 500, :conditions => {:id => (start_id..end_id)}) do |batch|
average_time = 0
total_time = 0
cdrs = Cdr.count(:conditions => {:traffic_type => 1})
total_processed = 0
batches = 0
Cdr.find_in_batches(:batch_size => 500, :select => "id,date,disposition,duration,account_id,cost,country_id", :conditions => {:traffic_type => 1}) do |batch|  
  batches += 1
	t = Time.now
	last = nil
	size = batch.size
	total_processed += size
  batch.each do |cdr|
    last = cdr
    cdr.update_cached_stuff
  end
  total_time += (Time.now - t)
  avg = total_time.to_f / batches
  remaining = cdrs - total_processed
  eta = (remaining / size) * avg

	f.write "ETA: #{stringify_seconds(eta)} ( Finish @ #{(Time.now + eta).strftime('%a %H:%M:%S')})\tRemaining Records: #{number_with_delimiter(remaining)}\tAvg Time Per #{size} Recs: #{sprintf("%.2f", (avg))}\n"
	f.flush
end
f.write "Finished @ #{Time.now}\n"
f.close

