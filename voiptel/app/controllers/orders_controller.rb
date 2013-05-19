class OrdersController < ApplicationController
  def index
    has_pager(Order, {}, 30)
    @orders = Order.find(:all, :order => "created_at DESC", :offset => @start, :limit => @limit)

    resp
  end

  def void
    resp
  end

  def log
    ot = OrderTransaction.find(:first, :conditions => {:order_id => params[:id]})
    @log = ""
    log_params = ot.params
    log_params.keys.each do |k|
      @log = @log + k + ": " + log_params[k].to_s + "<br>\n"
    end
    resp
  end

  def get_transactions
    transaction = params[:transaction]
    date = Chronic.parse(transaction[:date])
    d1 = date.beginning_of_day.utc
    d2 = date.end_of_day.utc
    @transactions = OrderTransaction.find(:all, :conditions => ["account_id = ? and created_at >= ? and created_at <= ?", transaction[:account_id], d1, d2], :order => "created_at asc")
    resp
  end

  def do_void
    transaction = OrderTransaction.find(params[:id])
    transaction.void
    d1 = transaction.created_at.beginning_of_day.utc
    d2 = transaction.created_at.end_of_day.utc
    @transactions = OrderTransaction.find(:all, :conditions => ["account_id = ? and created_at >= ? and created_at <= ?", transaction.account_id, d1, d2], :order => "created_at asc")
    resp
  end

  def stats
    @total_deposits = OrderTransaction.sum(:amount, :conditions => ["success = ? and created_at >= ? and created_at <= ? and account_id != ?", true, Time.now.beginning_of_month.utc, Time.now.utc, 291]) / 100.0
    @number_of_deposits = OrderTransaction.count(:amount, :conditions => ["success = ? and created_at >= ? and created_at <= ? and account_id != ?", true, Time.now.beginning_of_month.utc, Time.now.utc, 291])
    @total_balance = Account.sum(:balance, :conditions => ["status = ? and account_type = ?",1,1])
    @average_daily = @total_deposits / Time.now.day.to_f
    @credits = Credit.sum(:amount, :conditions => ["created_at >= ? and created_at <= ?", Time.now.beginning_of_month.utc, Time.now.end_of_month])
    @total_members = Account.count(:all, :conditions => ["status = ? and account_type = ?",1,1])
    @paying_members = data_paying_members()
    @used = Cdr.answer.cc.between(Time.now.beginning_of_month.utc..Time.now.utc).sum(:cost)
  end

    def data_paying_members()
      current_month_paying_member_count = 0
      for a in Account.find(:all, :conditions => ["account_type = ? and status = ?", 1,1])
        if OrderTransaction.find(:first, :conditions => ["success = ? and created_at >= ? and created_at <= ? and account_id = ?", true, Time.now.beginning_of_month.utc, Time.now.utc, a.id])
            current_month_paying_member_count += 1
        end
      end
      current_month_paying_member_count
    end
end
