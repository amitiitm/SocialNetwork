Account.all do |a|
  a.pin = ""
 if a.save
	puts "saved"
else
puts "error"
end

end
