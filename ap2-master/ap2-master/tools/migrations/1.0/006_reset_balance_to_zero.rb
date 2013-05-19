Account.all.each do |account|
  account.balance = 0
  account.save
end