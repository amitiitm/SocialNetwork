class Accounts::CreditsController < ApplicationController
  def create
    @account = Account.find(params[:account_id])
    @credit = Credit.new(params[:credit])

    if params[:credit][:category] == "1"
      @account.current_debt = @account.current_debt.to_f + @credit.amount.to_f
      @credit.current_debt = @account.current_debt
    end

    @credit.account = @account
    @path = account_billing_index_path
    cond = "account_id = #{params[:account_id]} AND category != 0 "
    # has_pager(Credit, {:account_id => params[:account_id]}, 10)
    has_pager(Credit, cond, 10)
    resp @credit.save
  end
end
