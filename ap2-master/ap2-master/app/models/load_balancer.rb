class LoadBalancer < ActiveRecord::Base
  belongs_to :server
  
  PROBE_MODES = [
    ["No Probing", 0],
    ["Probe Disable", 1],
    ["Probe Always", 2]
  ]
end
