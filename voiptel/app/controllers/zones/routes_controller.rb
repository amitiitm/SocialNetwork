class Zones::RoutesController < ApplicationController
  def index
    @zone = Zone.find(params[:zone_id])
    @routes = @zone.routes.find(:all, :order => "priority asc")
    resp
  end
  
  def create
    @zone = Zone.find(params[:zone_id])
    routes = params[:routes]
    @bulk_routes = BulkRoute.new(routes, @zone)
    @bulk_routes.save
    resp
  end
end
