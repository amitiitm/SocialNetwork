deleted = 0
Account.all.each do |account|
  hash = Hash.new
  # first find all easy dilers with highest freq
  phone_books = PhoneBook.find(:all, :conditions => {:account_id => account.id}, :order =>"freq DESC")
  for p in phone_books
    unless hash[p.easy_dial_number]
      hash[p.easy_dial_number] = {:correct => p, :others => []}
    else
      hash[p.easy_dial_number][:others] << p
    end
  end

  hash.keys.each do |key|
    correct = hash[key][:correct]
    puts "Phone Number: #{correct.phone_number} EasyDial: #{correct.easy_dial_number} Freq: #{correct.freq}"
    if hash[key][:others].size > 0
      puts "Others:"
      freq = 0
      hash[key][:others].each do |other|
        puts "\tPhone Number: #{other.phone_number} Freq: #{other.freq} obj id: #{other.id}"
        freq += other.freq
        puts "\t\t -- Deleting #{other.id}"
        PhoneBook.delete(other)
        deleted += 1
      end
      correct.freq += freq
      correct.save
    end
  end
  puts "--------------------------------------------------"
end
puts "Number of deleted entryes: #{deleted}"