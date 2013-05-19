namespace :db do
  desc "Load seed fixtures (from db/fixtures) into the current environment's database." 
  task :seed => :environment do
    require 'active_record/fixtures'
    Dir.glob(RAILS_ROOT + '/db/fixtures/*.yml').each do |file|
      Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
    end
  end

  desc 'Create YAML test fixtures from data in an existing database.    
  Defaults to development database. Set RAILS_ENV to override.'  
  #syntax to use this task: rake db:extract_fixtures FIXTURES=<, seperate table list>
  task :extract_fixtures => :environment do    
    sql = "SELECT * FROM %s"    
    skip_tables = ["schema_info", "sessions"]    
    ActiveRecord::Base.establish_connection    
    tables = ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : ActiveRecord::Base.connection.tables - skip_tables    
    tables.each do |table_name|      
      i = "000"      
      File.open("#{RAILS_ROOT}/db/#{table_name}.yml", 'w') do |file|        
        data = ActiveRecord::Base.connection.select_all(sql % table_name)        
        file.write data.inject({}) { |hash, record|          
          hash["#{table_name}_#{i.succ!}"] = record          
          hash        
        }.to_yaml      
      end    
    end  
  end
end


#require 'find'namespace :db do  
#desc "Backup the database to a file. Options: DIR=base_dir RAILS_ENV=production MAX=20"   
#  task :backup => [:environment] do    
#     datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")    
#     base_path = ENV["DIR"] || "db"     
#     backup_base = File.join(base_path, 'backup')    
#     backup_folder = File.join(backup_base, datestamp)    
#     backup_file = File.join(backup_folder, "#{RAILS_ENV}_dump.sql.gz")  File.makedirs(backup_folder)    db_config = ActiveRecord::Base.configurations[RAILS_ENV]    sh "mysqldump -u #{db_config['username']} -p#{db_config['password']} -Q —add-drop-table -O add-locks=FALSE -O lock-tables=FALSE #{db_config['database']} | gzip -c > #{backup_file}"     dir = Dir.new(backup_base)    
#     all_backups = dir.entries[2..-1].sort.reverse    
#     puts "Created backup: #{backup_file}"     max_backups = ENV["MAX"].to_i || 20    unwanted_backups = all_backups[max_backups..-1] || []    
#     for unwanted_backup in unwanted_backups      
#       FileUtils.rm_rf(File.join(backup_base, unwanted_backup))      
#       puts "deleted #{unwanted_backup}"     
#     end    
#     puts "Deleted #{unwanted_backups.length} backups, #{all_backups.length - unwanted_backups.length} backups available"   
#     end
