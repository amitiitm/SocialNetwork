class Carriers::RateSheetsController < ApplicationController
  def create
    @carrier = Carrier.find(params[:carrier_id])
    @rate_sheet = RateSheet.new(params[:rate_sheet])
    
    if @rate_sheet.save
      @error = false
    else
      @error = @rate_sheet.errors.full_messages.join("\n")
    end
  end
  
  def edit
    @carrier = Carrier.find(params[:carrier_id])
    @rate_sheet = RateSheet.find(params[:id])
  end
  
  def update
    @carrier = Carrier.find(params[:carrier_id])
    @rate_sheet = RateSheet.find(params[:id])
    if @rate_sheet.update_attributes(params[:rate_sheet])      
      @error = false
    else
      @error = @rate_sheet.errors.full_messages.join("\n")
    end
  end
  
  def index
    @carrier = Carrier.find(params[:carrier_id])
    
    respond_to do |format|
      format.js {render :layout => false}
    end
  end
  
  def process_rate_sheets
    
  end
  
end
