class AccountEndpoint < ActiveRecord::Base
  belongs_to :account
  belongs_to :endpoint
  
  after_save :check_trusted
  
  private
  def check_trusted
    if self.endpoint.in
      context_info = "handler=trunk;peer=#{self.account.short_name};account=#{self.account.id}"
      self.endpoint.trusted_endpoint ||= TrustedEndpoint.new
      self.endpoint.trusted_endpoint.grp = 0
      self.endpoint.trusted_endpoint.ip = self.endpoint.ip
      self.endpoint.trusted_endpoint.mask = 32
      self.endpoint.trusted_endpoint.port = 0
      self.endpoint.trusted_endpoint.proto = 'any'
      self.endpoint.trusted_endpoint.context_info = context_info
      self.endpoint.trusted_endpoint.save
    else
      if self.endpoint.trusted_endpoint
        self.endpoint.trusted_endpoint.destroy
      end
    end
  end  
  
end
