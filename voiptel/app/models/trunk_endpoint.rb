class TrunkEndpoint < ActiveRecord::Base
  belongs_to :trunk
  belongs_to :endpoint
end
