class CardsController < ApplicationController
  def index
    has_pager(Card, nil)
    @cards = Card.find(:all, :conditions => @conditions, :offset => @start, :limit => @limit)
    
    resp  
  end
  
  def show
    @no_memo = params[:no_memo]
    @card = Card.find(params[:id])
    resp
  end
  
  def convert
    @account = Account.new
    @account.status = 1
    user = User.new
    user.auth_user = AuthUser.new
    card = Card.find(params[:id])
    card.tmp_phones.each do |p|
      user.phones << Phone.new(:number => p.number)
    end
    @account.users << user
    resp
  end

end
