usernames = {}

while usernames.size < 10_000
  u = SipAccount.random_text(12, "char", 3, "-")
  p = SipAccount.random_text(20, "char", 4)
  unless usernames[u]    
    asa = AvailableSipAccount.new(:username => u, :password => p)
    begin
      asa.save
      usernames[u] = p 
    rescue Exception => e
      puts "Oops! Duplicate #{u} or #{p}"      
    end    
  end
end

puts usernames.size