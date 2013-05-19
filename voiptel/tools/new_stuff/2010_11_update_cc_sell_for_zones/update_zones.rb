def sell(buy, did, value, comission)
  comission = comission 
  balance = value - (value * comission)
  termination_cost = (buy + did)
  minutes_for_balance = (balance / termination_cost).to_i
  sell_price = (value.to_f / minutes_for_balance)
  sell_price
end

for z in Zone.all
  cost = sell(z.buy_rate, 0.002, 5, 0.40)
  cc_sell = (cost) + (cost * 0.01)
  if cc_sell < z.sell_rate
    cc_sell = z.sell_rate
  end
  
  z.cc_sell_rate = cc_sell
  z.save
  
  puts "#{z.name} carrier rate:#{z.buy_rate} cost: #{cost}"
end

