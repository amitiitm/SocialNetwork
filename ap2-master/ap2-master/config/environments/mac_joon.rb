# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = false

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = true

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

config.cache_store = :mem_cache_store
config.action_controller.perform_caching = true

config.action_mailer.smtp_settings = {
  :address              => "mail.openfo.com",
  :port                 => 587,
  :domain               => 'openfo.com',
  :user_name            => 'mnavid@openfo.com',
  :password             => 'moe1105',
  :authentication       => 'plain',
  :enable_starttls_auto => true
}

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
  paypal_options = {
    :login => "mnavid_1300111881_biz_api1.openfo.com",
    :password => "HB26K76MHJK9GYE6",
    :signature => "AF2TET1iD5OjgFsdfn6Mk.lpzKheAvnb7li5gxyjiVY7SNz3UPhqqqDI"
  }

  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)

  Gateway.mode = :test
  Gateway.gateway = Paypal
  ::GATEWAY = Gateway.new(paypal_options)
end