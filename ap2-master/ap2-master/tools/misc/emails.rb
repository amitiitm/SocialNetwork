for a in Account.find(:all, :conditions => {:status => 1})
	for u in a.users
		if not u.email.blank?
			puts "#{a.name},#{u.first_name} #{u.last_name},#{u.email},#{a.number}"
		end
	end
end

