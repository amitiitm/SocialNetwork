class TrustedEndpoint < ActiveRecord::Base
  belongs_to :endpoint
  belongs_to :server
end
