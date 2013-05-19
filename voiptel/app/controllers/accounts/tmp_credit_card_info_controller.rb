class Accounts::TmpCreditCardInfoController < ApplicationController
  skip_filter :login_required, :only => [:authorize]
  
  def new
    @account = Account.find(params[:account_id])
    @tmp_credit_card_info = TmpCreditCardInfo.new
    @tmp_credit_card_info.address = Address.new
    resp
  end
  
  def edit
    @account = Account.find(params[:account_id])
    @tmp_credit_card_info = TmpCreditCardInfo.find(params[:id])
    resp
  end
  
  def update
    @tmp_credit_card_info = TmpCreditCardInfo.find(params[:id])
    @path = account_billing_index_path(params[:account_id])
    resp @tmp_credit_card_info.update_attributes(params[:tmp_credit_card_info])
  end
  
  def create
    @tmp_credit_card_info = TmpCreditCardInfo.new(params[:tmp_credit_card_info])
    @tmp_credit_card_info.account_id = params[:account_id]
    @tmp_credit_card_info.admin_user = session[:user]
    @path = account_billing_index_path(params[:account_id])
    resp @tmp_credit_card_info.save
  end
  
  def destroy
    @tmp_credit_card_info = TmpCreditCardInfo.find(params[:id])
    @path = account_billing_index_path(params[:account_id])
    @tmp_credit_card_info.destroy
  end
  
  def authorize
    account = Account.find(params[:account_id])
    cc = CreditCard.new(params[:credit_card])
    @response = TmpCreditCardInfo.authorize(account, cc)
    render :layout => false    
  end
end
