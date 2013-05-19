class Accounts::OrderTransactionsController < ApplicationController
  def create
    @account = Account.find(params[:account_id])

    @order_transaction = OrderTransaction.new()
    @order_transaction.action = "purchase"
    @order_transaction.amount = params[:payment][:paypal].to_i * 100
    @order_transaction.success = 1
    @order_transaction.authorization = params[:paypal][:transaction]
    @order_transaction.message = "Success"
    @order_transaction.account_id = params[:account_id]
    @order_transaction.status = 1
    @order_transaction.full_amount = params[:payment][:paypal].to_f
    @order_transaction.charged_by = session[:user].name
    @order_transaction.old_balance = @account.balance.to_f

    acnt_blnc = 0

    if @account.current_debt > 0
      if params[:payment][:paypal].to_f > @account.current_debt
        blnc = params[:payment][:paypal].to_f - @account.current_debt.to_f
        acnt_blnc = blnc + @account.balance

        @order_transaction.current_debt = 0

        @acc = Account.find(params[:account_id])
        @acc.balance = acnt_blnc
        @acc.deposits += params[:payment][:paypal].to_f
        @acc.last_deposit_amount = params[:payment][:paypal].to_f
        @acc.last_deposit_date = Time.now.utc
        @acc.current_debt = 0
        @acc.save(false)
      end
  
      if params[:payment][:paypal].to_f < @account.current_debt
        crd_blnc = @account.current_debt.to_f - params[:payment][:paypal].to_f
        
        @acc = Account.find(params[:account_id])
        @acc.current_debt = crd_blnc
        @acc.deposits += params[:payment][:paypal].to_f
        @acc.last_deposit_amount = params[:payment][:paypal].to_f
        @acc.last_deposit_date = Time.now.utc
        @acc.save
        
        acnt_blnc = @acc.balance

        @order_transaction.current_debt = crd_blnc
      end

      if params[:payment][:paypal].to_f == @account.current_debt
        @acc = Account.find(params[:account_id])
        @acc.current_debt = 0
        @acc.deposits += params[:payment][:paypal].to_f
        @acc.last_deposit_amount = params[:payment][:paypal].to_f
        @acc.last_deposit_date = Time.now.utc
        @acc.save(false)
        acnt_blnc = @acc.balance

        @order_transaction.current_debt = 0
      end
    else
      acnt_blnc = @account.balance.to_f + params[:payment][:paypal].to_f
      @account.balance = acnt_blnc
      @account.deposits += params[:payment][:paypal].to_f
      @account.last_deposit_amount = params[:payment][:paypal].to_f
      @account.last_deposit_date = Time.now.utc
      @account.save
    end

    if acnt_blnc > 0
      @order_transaction.new_balance = acnt_blnc
    end

    @path = account_billing_index_path
    has_pager(OrderTransaction, {:account_id => params[:account_id]}, 10)
    resp @order_transaction.save
  end
end
