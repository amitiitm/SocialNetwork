class BulkRoute
  attr_accessor :routes, :zone
  
  def initialize(routes, zone)
    if routes
      self.routes = routes
    else
      self.routes = {}
    end
    self.zone = zone
  end
  
  def save
    if self.routes.keys.size == 0
      # delete all routes
      self.zone.routes.delete_all
      self.zone.routes_count = self.zone.routes.count
      self.zone.save(false)
      return true
    end
    
    # replace all routes
    self.zone.routes.find(:all, :order => "priority asc").each do |r|
      p = r.priority.to_s
      
      if self.routes[p]
        if self.routes[p][:carrier].blank?
          r.carrier_id = nil
        else
          r.carrier_id = self.routes[p][:carrier].to_i
        end        
        r.try = self.routes[p][:try].to_i
        r.save
        self.routes.delete(p)
      else
        r.delete
      end
    end
    
    self.routes.keys.each do |k|
      p = k.to_i
      r = Route.new
      r.zone_id = self.zone.id
      
      if self.routes[k][:carrier].blank?
        r.carrier_id = nil
      else
        r.carrier_id = self.routes[k][:carrier].to_i
      end
      
      r.try = self.routes[k][:try].to_i
      r.priority = p
      r.save
    end
    self.zone.routes_count = self.zone.routes.count
    self.zone.save(false)
    return true
  end
end