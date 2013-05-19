class Carriers::Trunks::RateSheetsController < ApplicationController
  
  def index
    @trunk = Trunk.find(params[:trunk_id])
    @rate_sheets = @trunk.rate_sheets.find(:all, :order => "created_at DESC")
    respond_to do |format|
      format.js {render :layout => false}
    end
  end
  
  def new
    @trunk = Trunk.find(params[:trunk_id])
    @rate_sheet = RateSheet.new(:trunk_id => @trunk.id, :carrier_id => @trunk.carrier.id, :time_zone => "UTC")
    respond_to do |format|
      format.js {render :layout => false}
    end
  end
  
  def create
    date = params[:date]
    @rate_sheet = RateSheet.new(params[:rate_sheet])
    tz = ActiveSupport::TimeZone.new(@rate_sheet.time_zone)
    logger.info { "tz: #{tz.to_s}" }
    ed = @rate_sheet.effective_date = tz.parse("#{date[:year]}-#{date[:month]}-#{date[:day]} 00:00:00")
    if @rate_sheet.save
      @errors = false
    end
    index
  end
end
