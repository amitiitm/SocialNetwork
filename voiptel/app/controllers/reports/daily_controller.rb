class Reports::DailyController < ApplicationController
  def show
    resp
  end
  def daily_graph
    @daily_traffic = CachedApDailyCdr.daily_traffic_for(params[:year], params[:month])
    @daily_average = CachedApDailyCdr.daily_average_for(params[:year], params[:month])
    resp
  end
end
