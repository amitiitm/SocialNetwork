for a in Account.find(:all, :conditions => {:status => 1})
  for ot in a.order_transactions.find(:all, :conditions => {:success => true})
    a.increment_cached_deposits(ot.amount/100.0, ot.created_at.utc)
  end
end
