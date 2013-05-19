::OPENFO = YAML::load(File.open("#{RAILS_ROOT}/config/openfo.yml"))[RAILS_ENV]

::BZR_INFO = `git log -1 --pretty=medium`.gsub("\n\n", "\n").gsub("\n", "<br>")

::MY_REDIS = Redis.new(:host => OPENFO["redis"]["host"])

::DB_OPENSIPS = YAML::load(File.open("#{RAILS_ROOT}/config/database.yml"))["opensips_#{RAILS_ENV}"]

::MY_VIEW = ActionView::Base.new(Rails::Configuration.new.view_path)

#require 'resque'
#Resque.redis = MY_REDIS
