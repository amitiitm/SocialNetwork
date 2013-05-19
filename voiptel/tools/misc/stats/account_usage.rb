6.upto(9) do |m|  
  date = Chronic.parse("2009-0#{m}-01")
  starting = date.utc.beginning_of_month.to_formatted_s(:db)
  ending   = date.utc.end_of_month.to_formatted_s(:db)
  puts "------------ MONTH: #{m} [#{starting}-#{ending}]------------"
  for a in Account.find(:all, :conditions => ["created_at < ?", starting])
    usage = Cdr.sum(:duration, :conditions => ["account_id = ? and date > ? and date < ? and disposition = ?", a.id, starting, ending, "ANSWER"])
    total_deposits = OrderTransaction.sum(:amount, :conditions => ["created_at > ? and created_at < ? and success = ? and account_id = ?", starting, ending, true, a.id])
    number_of_deposits = OrderTransaction.count(:conditions => ["created_at > ? and created_at < ? and success = ? and account_id = ?", starting, ending, true, a.id])
    puts "#{a.name},#{usage/60},#{total_deposits/100},#{number_of_deposits}"
  end
end