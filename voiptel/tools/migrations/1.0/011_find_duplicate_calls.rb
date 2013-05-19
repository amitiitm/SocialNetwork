def seperate(cdr)
  name = (cdr.user) ? cdr.user.name : "NONE"
  src = cdr.src.match(/[0-9]+/)[0].gsub(/[<> ]/,"")
  puts "--------------------------------------------------------------"
  puts "Name:#{name},Src:#{src},Dst Num:#{cdr.dst_number},Dst Country:#{CountryCode.new.country_name(cdr.dst_number)}"
  puts "ID,Date,Duration,Disposition"
end

def print_record_info(cdr)
  puts "#{cdr.id},\"#{cdr.date}\",#{cdr.duration},#{cdr.disposition}"
end
duplicates = Hash.new
unique = Hash.new
for account in Account.all
  cdrs = Cdr.find_all_by_account_id(account.id)
  i = 0
  j = 0
  while i < cdrs.length
    j = i
    while j < cdrs.length
      base_call = cdrs[i]
      if j + 1 >= cdrs.length
        break
      else
        next_call = cdrs[j+1]
      end
      unless unique.key?(base_call.id)
        if (base_call.date.to_i + base_call.duration) > next_call.date.to_i
          # We have problem        
          if base_call.phone_id == next_call.phone_id
            unless duplicates[base_call.id]
              seperate(base_call)
              print_record_info(base_call)
              print_record_info(next_call)
              duplicates[base_call.id] = [next_call.id]
              unique[next_call.id] = true
            else
              duplicates[base_call.id] << [next_call.id]
              print_record_info(next_call)
              unique[next_call.id] = true
            end
          end    
        end 
      end
      j +=1
    end
    i += 1
  end
end
