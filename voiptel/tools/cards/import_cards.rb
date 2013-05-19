n = 0
Excelsior::Reader.rows(File.open(ARGV[0], 'rb')) do |row|
  n += 1
  c = Card.new
  c.serial = row[0]
  c.serial_number = n
  c.number = row[1]
  c.balance = row[2].to_i
  c.value = row[2].to_i
  c.save
end