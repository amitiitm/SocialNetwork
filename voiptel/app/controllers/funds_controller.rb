class FundsController < ApplicationController
  def index
  end
  
  def add
    @account = Account.find(params[:id])
    @account_holder_name = User.find(@account.account_holder_id).name
  end

end
