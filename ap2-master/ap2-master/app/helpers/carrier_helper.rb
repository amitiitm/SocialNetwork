module CarrierHelper
  def endpoints(trunk)
    endpoints = []
    trunk.endpoints.each do |e|
      endpoints << e.name
    end
    endpoints.join(", ")
  end
  
  def revesion_files(rev)
    
  end
end
