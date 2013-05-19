class CreditCardController < ApplicationController
  def new
    @account = Account.find(params[:id])
  end
  
  def save
    @errors = Hash.new
    @account = Account.find(params[:id])
    
    credit_card = CreditCard.new(params[:credit_card])
    billing_address = Address.new(params[:billing_address])
    
    unless credit_card.valid?
      @errors = process_errors(credit_card, @errors)
    end
    
    unless billing_address.valid?
      @errors = process_errors(billing_address, @errors)
    end
    
    unless @errors.size > 0
      credit_card.billing_address = billing_address
      credit_card.user_id = @account.account_holder_id
      credit_card.account_id = @account.id
      credit_card.save
      logger.info { "ERRORS: #{credit_card.errors}" }
      if credit_card.errors.size > 0
        logger.info { "ERRORS: #{credit_card.errors}" }
        @errors = process_errors(credit_card, @errors)
      end
    end
  end
  
  def delete
    tr = TransactionReference.find(params[:id])
    @account_id = tr.account.id
    tr.delete
  end
  
  def charge
    @error = false
    recharge = params[:charge]
    amount = recharge[:amount].to_f
    credit_card_id = recharge[:credit_card_id]
    account = Account.find(params[:id])
    order = Order.new
    order.account_id = account.id
    order.user_id = account.account_holder_id
    order.amount = amount
    order.purchase_by_reference(TransactionReference.find(credit_card_id))
    order.save
    if order.order_transaction.success
      account = Account.find(params[:id])
      account.status = 1
      account.balance += amount
      account.deposits += amount
      account.last_deposit_amount = amount
      account.last_deposit_date = Time.now.utc
      account.save
    else
      @error = true
    end
  end
end
