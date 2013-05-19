def test
  puts('Enter one number')
  a = gets.chomp
  puts('Enter second number')
  b = gets.chomp
  c = sum(a,b)
  puts("Sum is #{c}")
end

def sum(a,b)
  c = a + b
end

test