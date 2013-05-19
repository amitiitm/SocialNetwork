h = Hash.new
  500.times do |i|
  continue = true
  while continue
    r = rand(1_000_000)
    if not h.key?(r) and (r < 999999 and r > 100000)
      h[r] = 1
      continue = false
      acn = AccountNumber.new
      acn.number = r
      acn.save
    end
  end
end

