class ZonesController < ApplicationController
  def index
    resp
  end
  
  def show
    @zone = Zone.new
    @country = Country.find(params[:id])
    @zones = @country.zones
    @action = "show"
    resp
  end
  
  def batch_view
    show
  end
  
  def create
    @zone = Zone.new(params[:zone])
    @zone.save
  end
  
  def update
    @zone = Zone.find(params[:id])
    @zone.update_attributes(params[:zone])
  end
  
  def save_all
    zones = params[:zones]
    routes = params[:routes]
    if zones
      zones.keys.each do |id|        
        zone = Zone.find(id.to_i)
        zone.update_attributes(zones[id])
        if routes
          route = routes[id]
          r = BulkRoute.new(route, zone)
          r.save
        end
      end
    end
  end
  
  def delete_all
    ids = params[:ids]
    ids.split(",").each do |id|
      id = id.to_i
      Zone.find(id).delete
    end
  end
  
  def destroy
    @zone = Zone.find(params[:id])
    @zone.delete
  end
  
  def new
    @country = Country.find(:first, :conditions => ["country_code = ?", params[:id]])
    @carriers = carriers
    @zone = Zone.new
  end
  
  def create_zone    
    @zone = Zone.new(params[:zone])
    @cid = @zone.country.country_code
    @carriers = carriers
    @error = nil
    if @zone.save
      # some code later on
    else
      @error = err("Could not create new zone:", @zone.errors)
    end
  end
  
  def destroy_zone
    zone = Zone.find(params[:id])    
    zone.destroy
  end
  
  def update_single_zone
    zone = Zone.find(params[:id])
    carrier = params[:carrier]
    @error = nil
    if zone.update_attributes(params[:zone])
      zone.routes.each do |route|
        route.carrier_id = carrier[route.priority.to_s]
        route.save
      end
    else
      @error = err("Could not save changes:", zone.errors.full_messages.join(". "))
    end
  end
  
  def update_zone
   zones = params[:zone]
   @error = nil
   zones.keys.each do |key|
     zone = Zone.find(key.to_i)
     if zone.update_attributes(zones[key])
       zone.routes.each do |route|
         route.carrier_id = zones[key][:carrier][route.priority.to_s]
         route.save
       end
     else
       @error = err("Could not save changes:", zone.errors.full_messages.join(". "))
     end
   end
  end
  
  private
  def carriers
    Carrier.all.collect {|c| [c.name, c.id]}
  end
  
  def err(msg, errors)
    err = "#{msg}\n"
    errors.each{|attr,msg| err += "#{attr} - #{msg}\n" }
    return err
  end
end