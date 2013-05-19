class Carriers::Trunks::RateSheets::RateSheetFilesController < ApplicationController
  def show
    @rate_sheet_file = RateSheetFile.find(params[:id])
    respond_to do |wants|
      wants.js { render :layout => false }
    end
  end
  
  def update
    @trunk = Trunk.find(params[:trunk_id])
    @rate_sheets = @trunk.rate_sheets.find(:all, :order => "created_at DESC")        
    @rate_sheet_file = RateSheetFile.find(params[:id])
    if @rate_sheet_file.update_attributes(params[:rate_sheet_file])
      @errors = false
    else
      @errors = @rate_sheet_file.errors.full_messages.join("\n")
    end
  end
end
