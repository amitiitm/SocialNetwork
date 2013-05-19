class PromotionsController < ApplicationController
  
  def index
    @promotions = Promotion.find(:all, :conditions => {:promotion_type => 1})
    resp
  end
  
  def edit  
    @promotion = Promotion.find(params[:id])
    resp
  end
  
  def new
    @promotion = Promotion.new
    resp
  end
  
  def update
    @path = promotions_path
    @promotion = Promotion.find(params[:id])
    resp(@promotion.update_attributes(params[:promotion]))
  end
    
  def destroy
    @path = promotions_path
    @promotion = Promotion.find(params[:id])
    @promotion.delete
  end
  
  def create
    @path = promotions_path
    @promotion = Promotion.new(params[:promotion])
    resp(@promotion.save)
  end
  
end
