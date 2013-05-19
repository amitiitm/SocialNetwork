# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Tekweld2::Application.initialize!
Date::DATE_FORMATS.merge!(:default => "%Y/%m/%d")

#Mime::Type.register 'application/pdf', :pdf ## for pdf writer testing