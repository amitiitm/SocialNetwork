class Accounts::AccountPromotionsController < ApplicationController
  def index
    @account = Account.find(params[:account_id])
    @promotions = @account.promotions
    resp
  end
  
  def edit
    @account = Account.find(params[:account_id]) 
    @promotion = AccountPromotion.find(params[:id])
    resp
  end
  
  def update
    @path = account_promotions_path
    @promotion = AccountPromotion.find(params[:id])
    resp(@promotion.update_attributes(params[:account_promotion]))    
  end
  
  def new
    @account = Account.find(params[:account_id]) 
    @promotion = AccountPromotion.new
    resp
  end
  
  def destroy
    @path = account_promotions_path
    @promotion = AccountPromotion.find(params[:id])
    @promotion.delete
  end
  
  def create
    @path = account_promotions_path
    @promotion = AccountPromotion.new(params[:account_promotion])
    resp(@promotion.save)
  end
end
