Address.all.each do |address|
  address.address1 = address.street
  address.save
end