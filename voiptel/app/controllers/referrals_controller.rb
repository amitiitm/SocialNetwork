class ReferralsController < ApplicationController
  def index
    @referrals = Referral.find(:all, :order => "created_at DESC")
    resp
  end
  
  def unmatched
    @referrals = Referral.find(:all, :conditions => {:mapped => false}, :order => "created_at DESC")
    resp
  end

  def matched
    @referrals = Referral.find(:all, :conditions => {:mapped => true}, :order => "match_date DESC")
    resp
  end

    
  def update
    @referral = Referral.find(params[:id])
    if @referral.update_attributes(params[:referral])
      @success = true
    else
      @success = false
    end
  end
  
  def edit
    @referral = Referral.find(params[:id])
    resp
  end
  
end
