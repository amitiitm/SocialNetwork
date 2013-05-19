class Reports::MonthlyController < ApplicationController  
  def show
    resp
  end
  
  def monthly_graph
    @monthly_traffic = CachedApCdr.monthly_traffic_for_year(params[:year])
    @daily_average = CachedApCdr.daily_average_for_year(params[:year])
    resp    
  end  
end
