for phone in Phone.all
  phone.deleted = false
  phone.save
end