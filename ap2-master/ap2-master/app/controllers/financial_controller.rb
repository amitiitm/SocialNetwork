class FinancialController < ApplicationController
  def stats
    start_date = Time.now.beginning_of_month.utc.to_formatted_s(:db)
    end_date = Time.now.utc.to_formatted_s(:db)
    
    @total_balance = Account.sum(:balance, :conditions => ["status = 1 and balance > 0 and account_type = 1"])
    @total_deposits = (OrderTransaction.sum(:amount, :conditions => ["success = 1 and created_at >= ? and created_at <= ?", start_date, end_date]) / 100)
    @total_taxes = OrderTransaction.sum(:tax_amount, :conditions => ["success = 1 and created_at >= ? and created_at <= ?", start_date, end_date])
    @positive_credits = Credit.sum(:amount, :conditions => ["amount > 0 and created_at >= ? and created_at <= ?", start_date, end_date])
    @negative_credits = Credit.sum(:amount, :conditions => ["amount < 0 and created_at >= ? and created_at <= ?", start_date, end_date])
    
    resp
  end
end
