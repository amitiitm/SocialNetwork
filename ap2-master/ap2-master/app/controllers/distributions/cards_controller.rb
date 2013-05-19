class Distributions::CardsController < ApplicationController
  
  def index
    has_pager(Card, {:distribution_id => params[:distribution_id]})
    @distribution = Distribution.find(params[:distribution_id])
    @cards = Card.find(:all, :conditions => @conditions, :offset => @start, :limit => @limit)
    
    resp      
  end
  
  def used
    has_pager(Card, {:distribution_id => params[:distribution_id], :used => 1})
    @distribution = Distribution.find(params[:distribution_id])
    @cards = Card.find(:all, :conditions => @conditions, :offset => @start, :limit => @limit)
    
    resp
  end
end
