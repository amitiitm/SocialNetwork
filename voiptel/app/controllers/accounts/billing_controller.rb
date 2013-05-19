class Accounts::BillingController < ApplicationController
  layout nil
  def index
    @account = Account.find(params[:account_id])
    @cards = TransactionReference.find(:all, :conditions => {:account_id => @account.id})
  end

  def credit_cards
    @account = Account.find(params[:account_id])
    cond = "id NOT IN (SELECT id FROM transaction_references WHERE exp_year < #{Time.now.year}) AND id NOT IN (SELECT id FROM transaction_references WHERE exp_year = #{Time.now.year} AND exp_month < #{Time.now.month}) AND account_id = #{@account.id}"
    # @credit_cards = TransactionReference.find(:all, :conditions => {:account_id => @account.id},:order=> "position ASC")
    @credit_cards = TransactionReference.find(:all, :conditions => cond, :order=> "position ASC")
    render :partial => "accounts/billing/cards", :layout => nil
  end
  
  def transactions
    @account = Account.find(params[:account_id])
    has_pager(OrderTransaction, {:account_id => params[:account_id]}, 10)
    @transactions = OrderTransaction.find(:all, :conditions => @conditions, :order => "created_at DESC", :offset => @start, :limit => @limit)
    @order_transaction = OrderTransaction.new()
    render :partial => "accounts/billing/transaction", :layout => nil
  end
  
  def credits
    @account = Account.find(params[:account_id])
    @credit = Credit.new(:admin_user_id => session[:admin_user_id])
    cond = "account_id = #{params[:account_id]} AND category != 0"
    # has_pager(Credit, {:account_id => params[:account_id]}, 10)
    has_pager(Credit, cond, 10)
    @credits = Credit.find(:all, :conditions => cond, :order => "created_at DESC", :offset => @start, :limit => @limit)

    render :partial => "accounts/billing/credit", :layout => nil #"application"
  end

  def auto_recharge
    @account = Account.find(params[:account_id])
    render :partial=>'auto_recharge' ,:layout=>nil
  end

  def charge_view
    @account = Account.find(params[:account_id])
    @card = TransactionReference.find(:first, :conditions=>{:id => params[:id],:account_id =>params[:account_id]})
    resp
  end

  def update_autorecharge
    @account = Account.find(params[:account_id])
     session[:auto_recharge] =  params[:account][:auto_recharge] == "true" ? true : false
     @status = @account.update_attributes(params[:account])
  end

  
  def charge
    @error = false
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
    order.tax = tax
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
