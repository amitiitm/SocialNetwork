class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
  end

  def show
  end
  
  def new
    @campaign = Campaign.new
    resp
  end
  
  def create
    campaign = Campaign.new(params[:campaign])
    campaign.save
  end
  
  def edit
    @campaign = Campaign.find(params[:id])
    resp    
  end
  
  def update
    campaign = Campaign.find(params[:id])
    campaign.update_attributes(params[:campaign])
  end
  
  def destroy
    campaign = Campaign.find(params[:id])
    campaign.destroy
  end

end
