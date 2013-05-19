#require 'mongrel_cluster/recipes'

set :application, "biztracker"
#set :repository,  "file:///home/svn/biztracker/projects/biztracker"
set :repository,  "http://192.168.101.41/svn/biztracker/trunk"
set :user, "root"
set :password, "diaspark"
set :rake, "rake Rakefile" 
set :spinner, "false"
set :scm_username, 'purva'
set :scm_password, 'purva'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

set :deploy_via,  :export
set :runner, nil
set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml"
set :chmod755, "app config db lib public vendor script script/* public/disp* tmp log"

role :app, "192.168.101.41"
role :web, "192.168.101.41"
role :db,  "192.168.101.41", :primary => true



namespace(:deploy) do
   task :after_update_code, :roles => [:app, :db, :web] do
     # fix permissions
     run "chmod +x #{release_path}/script/process/reaper" 
     run "chmod +x #{release_path}/script/process/spawner" 
     run "chmod 755 #{release_path}/public/dispatch.*" 
    end

    desc 'Restart Purva reaper' 
    task :restart do
        run "ruby #{deploy_to}/current/script/process/reaper" 
     end
end

desc "Symlink the database config file from shared 
	directory to current release directory"
task :symlink_database_yml do
	run "ln -nsf #{shared_path}/config/database.yml
		#{release_path}/config/database.yml"
end

after 'deploy:update_code', 'symlink_database_yml'

