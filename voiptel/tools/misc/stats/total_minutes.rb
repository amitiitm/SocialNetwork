first_call = Cdr.first.date
current_month_start = first_call.beginning_of_month
current_month_end = current_month_start.end_of_month

while (current_month_end <= Time.now.end_of_month)
  seconds = Cdr.sum(:duration, :conditions => ["date > ? and date < ? and disposition = ?", current_month_start.utc.to_formatted_s(:db), current_month_end.utc.to_formatted_s(:db), "ANSWER"])
  puts "#{current_month_start.strftime('%B, %Y')}: #{seconds/60}"
  current_month_start = current_month_start + 1.month
  current_month_end = current_month_start.end_of_month
end
