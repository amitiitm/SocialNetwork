class Accounts::SipAccountsController < ApplicationController
  def index
    @account = Account.find(params[:account_id])
    @dids = @account.dids
    @sip_accounts = @account.sip_accounts
    resp
  end
  
  def new
    asa = AvailableSipAccount.first.delete
    @account = Account.find(params[:account_id])    
    @sip_account = SipAccount.new
    @sip_account.account = @account
    @sip_account.cid_name = @account.name
    @sip_account.username = asa.username
    @sip_account.password = asa.password
    @sip_account.domain = "home.openfo.com"    
    resp
  end
  
  def edit
    @account = Account.find(params[:account_id])
    @sip_account = SipAccount.find(params[:id])
    resp
  end
  
  def create
    @sip_account = SipAccount.new(params[:sip_account])
    @sip_account.account_id = params[:account_id]    
    @path = account_sip_accounts_path(params[:account_id])
    resp @sip_account.save
  end
  
  def update
    @sip_account = SipAccount.find(params[:id])    
    @path = account_sip_accounts_path(params[:account_id])
    resp @sip_account.update_attributes(params[:sip_account])
  end
  
  def destroy
    @sip_account = SipAccount.find(params[:id])
    @path = account_sip_accounts_path(params[:account_id])
    resp @sip_account.destroy
  end
end
