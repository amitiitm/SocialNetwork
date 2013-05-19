class AbstractGateway
  def authorize(amount, credit_card, options = {})
    $gateway.new(self).authorize(amount, credit_card, options)
  end
  
  def purchase(amount, card_or_reference, options = {})
    $gateway.new(self).purchase(amount, card_or_reference, options)
  end
  
  def refund(transactionid)
    $gateway.new(self).refund(transactionid)
  end
end