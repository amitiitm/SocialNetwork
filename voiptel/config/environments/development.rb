# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = false
ActiveRecord::Base.logger = Logger.new(STDOUT)
# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = true
config.log_level = :debug
# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

config.cache_store = :mem_cache_store
config.action_controller.perform_caching = true

#config.after_initialize do
#  ActiveMerchant::Billing::Base.mode = :test
#  ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
#    :login => "sl_1260575595_biz_api1.openfo.com",
#    :password => "1260575601",
#    :signature => "ASTcXBz4A3B8FVlO9mkaHEb6oEdjA81IVN0uhX2T6YC61HAIGkn8FDyv"
#  )
#end
#

config.after_initialize do
  Gateway.mode = :test
  Gateway.gateway = Paypal
  ::GATEWAY = Gateway.new(
    :login => "sl_1260575595_biz_api1.openfo.com",
    :password => "1260575601",
    :signature => "ASTcXBz4A3B8FVlO9mkaHEb6oEdjA81IVN0uhX2T6YC61HAIGkn8FDyv"
  )
end




