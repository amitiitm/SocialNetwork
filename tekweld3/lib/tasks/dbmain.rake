namespace :dbmain do
  desc "Retrieves the current schema version number"
  task :version => :environment do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end

  desc "Migrate the database through scripts in dbmain/migrate. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
  task :migrate => :environment do
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::Migrator.migrate("db/dbmainmigrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
  end

end
