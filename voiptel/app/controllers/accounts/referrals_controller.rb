class Accounts::ReferralsController < ApplicationController
    
  def index
    @account = Account.find(params[:account_id])
    @referrals = @account.referrals.find(:all, :order => "created_at desc")
    resp
  end
  
end
