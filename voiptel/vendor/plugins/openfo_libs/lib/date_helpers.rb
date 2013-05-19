def months_in_year(year, options = {})
  year = year.to_s
  if Time.now.year.to_s == year
    if options[:with_current_month]
      end_month = Time.now.month
    else
      end_month = Time.now.month - 1
    end    
  else
    end_month = 12
  end
  result = []
  (1..end_month).each do |m|
    if m < 10
      m = "0#{m}"
    end
    result << "#{year}-#{m}-01"
  end
  result
end

def days_in_month(year, month)
  year = year.to_i
  month = month.to_i
  (Date.new(year, 12, 31) << (12-month)).day
end
