class Accounts::CreditCardsController < ApplicationController
  
  def new
    @account = Account.find(params[:account_id])
    @credit_card = CreditCard.new
    resp
  end

  def update_position
      params[:credit_card].delete_at(0)
      params[:credit_card].each_with_index do |tr_id,index|
        tr = TransactionReference.find(:first, :conditions => {:account_id => params[:account_id], :id=>tr_id.to_i})
        tr.update_attributes(:position => index)
      end
      render :json=>true
  end
  
  def create
    @errors = []
    @account = Account.find(params[:account_id])

    credit_card = CreditCard.new(params[:credit_card])
    billing_address = Address.new(params[:address])
    #raise billing_address.inspect
    unless credit_card.valid?
      @errors << credit_card.errors
    end

    unless billing_address.valid?
      @errors << billing_address.errors
    end
    unless @errors.size > 0
      credit_card.billing_address = billing_address
      credit_card.user_id = @account.account_holder_id
      credit_card.account_id = @account.id
      options = {:admin_user_id => session[:admin_user_id]}
      credit_card.save(options)
      @path = account_billing_index_path(@account)
    end
    resp(@errors.size == 0)
  end

  def destroy
    tr = TransactionReference.find(:first, :conditions=>{:id => params[:id],:account_id =>params[:account_id]})
    tr.update_attributes(:is_deleted => true)
  end

  def charge
    @errors = []
    recharge = params[:charge]
    amount = recharge[:amount].to_f
    credit_card_id = recharge[:credit_card_id]
    account = Account.find(params[:account_id])
    
    # tax stuff
    product_tax = ProductTax.find(:first, :conditions => {:product_code => "access_connect", :enabled => true})
    tax = 0
    if product_tax
      tax = product_tax.total_tax * amount
    end
    
    order = Order.new
    order.account_id = account.id
    order.user_id = account.account_holder_id
    order.amount = amount
    tr = TransactionReference.find(credit_card_id)
    order.purchase_by_reference(tr , tax , OrderTransaction::AGENT,  session[:admin_user_id])
    order.save
    if order.order_transaction.success
      #account = Account.find(params[:id])
      if not order.order_transaction.authorization.blank?
        tr.reference = order.order_transaction.authorization
        tr.save
      end
      account.status = 1
      # account.balance += amount
      account.deposits += amount
      account.last_deposit_amount = amount
      account.last_deposit_date = Time.now.utc
      account.save

      acnt_blnc = 0
      @account = Account.find(params[:account_id])

      if @account.current_debt > 0
        if amount > @account.current_debt
          blnc = amount - @account.current_debt.to_f
          acnt_blnc = blnc + @account.balance
          # @order_transaction.current_debt = 0
          @acc = Account.find(params[:account_id])
          @acc.balance = acnt_blnc
          @acc.deposits += amount
          @acc.last_deposit_amount = amount
          @acc.last_deposit_date = Time.now.utc
          @acc.current_debt = 0
          @acc.save(false)
        end

        if amount < @account.current_debt
          crd_blnc = @account.current_debt.to_f - amount
          @acc = Account.find(params[:account_id])
          @acc.current_debt = crd_blnc
          @acc.deposits += amount
          @acc.last_deposit_amount = amount
          @acc.last_deposit_date = Time.now.utc
          @acc.save
          acnt_blnc = @acc.balance
          # @order_transaction.current_debt = crd_blnc
        end

        if amount == @account.current_debt
          @acc = Account.find(params[:account_id])
          @acc.current_debt = 0
          @acc.deposits += amount
          @acc.last_deposit_amount = amount
          @acc.last_deposit_date = Time.now.utc
          @acc.save(false)
          acnt_blnc = @acc.balance
          # @order_transaction.current_debt = 0
        end
      else
        acnt_blnc = @account.balance.to_f + amount
        @account.balance = acnt_blnc
        @account.deposits += amount
        @account.last_deposit_amount = amount
        @account.last_deposit_date = Time.now.utc
        @account.save
      end

    else
      @errors = ["order", [["error", order.order_transaction.message]]]
    end
    @path = account_billing_index_path(params[:account_id])
    resp(@errors.size == 0)
  end

end
