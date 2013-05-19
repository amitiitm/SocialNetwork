# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Use a different cache store in production
config.cache_store = :mem_cache_store

config.action_mailer.smtp_settings = {
  :address              => "mail.openfo.com",
  :port                 => 587,
  :domain               => 'openfo.com',
  :user_name            => 'mnavid@openfo.com',
  :password             => 'moe1105',
  :authentication       => 'plain',
  :enable_starttls_auto => true
}

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
 config.action_mailer.raise_delivery_errors = false

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :production
  ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
    :login => "paypal_api1.openfo.com",
    :password => "5JLQ2JLULBA44445",
    :signature => "AFcWxV21C7fd0v3bYYYRCpSSRl31AdOBF65IWQ9wSC8tOMtWS6Av3njo"
  )
end 
