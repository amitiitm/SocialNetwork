PHONE_TYPES = [
  "",
  "Home",
  "Mobile",
  "Work"
]
for a in Account.find(:all, :conditions => {:status => 1, :account_type => 1})
  for p in a.phones
    did = "N/A"
    if p.assigned_did
      did = p.assigned_did.did.number      
    end
    puts "#{a.name},#{p.user.name},#{p.number},#{PHONE_TYPES[p.phone_type]},#{did}"
  end
end