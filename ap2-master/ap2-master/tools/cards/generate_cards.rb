def generate_pin
  pin = rand * rand
  pin = pin.to_s.gsub("0.", "")[0..11]
  "#{pin[0..3]}-#{pin[4..7]}-#{pin[8..11]}"
end

def generate_serial(batch_code, number)
  
end

def number_with_dash(number, digits)
  number = number.to_s
  zeros = digits - number.length
  zeros.times { number = "0#{number}"}
  "#{number[0..1]}-#{number[2..4]}"
end

pins = Hash.new
counter = 0
while pins.size < 10_000
  pin_code = generate_pin()
  unless pins[pin_code]
    pins[pin_code] = true
  end
end

pins.keys.each do |k|
  counter += 1
  puts "#{k},AA-#{number_with_dash(counter, 5)}"
end