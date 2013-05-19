for account in Account.all
  #for user in account.users
  	cdrs = Cdr.find(:all, :conditions => ["account_id = ? and (disposition = 'ANSWER' or disposition = 'CANCEL')", account.id])
  	phone_book = Hash.new
  	for cdr in cdrs
  	  if phone_book[cdr.dst_number]
  	    phone_book[cdr.dst_number] += 1
  	  else
  	    if cdr.dst_number.length > 8
  	      phone_book[cdr.dst_number] = 1
  	    end
  	  end
  	end

  	phone_book.keys.each do |k|
  	  length = k.length
  	  easy_dial_number = k[length-4..-1]
  	  p = PhoneBook.new(:account_id => account.id, :phone_number => k, :easy_dial_number => easy_dial_number, :freq => phone_book[k])
  	  p.save
  	end
	#end
end
