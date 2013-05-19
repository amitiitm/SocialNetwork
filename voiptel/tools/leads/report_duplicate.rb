f = File.open(ARGV[0], "r")

f.each_line do |l|
  number = l.strip
  phone = Phone.find(:first, :conditions => {:number => number})
  tmp_phone = TmpPhone.find(:first, :conditions => {:number => number})
  lead = nil #Lead.find(:first, :conditions => {:phone => number})
  
  if phone
    puts "#{number},AC"
  elsif tmp_phone
    puts "#{number},CC"
  elsif lead
    puts "#{number},Lead"
  end  
end