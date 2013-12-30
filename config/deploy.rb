# RVM bootstrap
### switched to rbenv
###$:.unshift(File.expand_path("~/.rvm/lib"))
###require 'rvm/capistrano'
###set :rvm_ruby_string, '1.9.2-p180'
###set :rvm_type, :system

# bundler bootstrap
require 'bundler/capistrano'

set :application, "pbc3.1"

role :web, "www.pbc.org"                          # Your HTTP server, Apache/etc
role :app, "www.pbc.org"                          # This may be the same as your `Web` server
role :db,  "www.pbc.org", :primary => true # This is where Rails migrations will run
#role :web, "test.pbc.org"                          # Your HTTP server, Apache/etc
#role :app, "test.pbc.org"                          # This may be the same as your `Web` server
#role :db,  "test.pbc.org", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

#server
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/srv/rails/#{application}"
set :user, "webapp"
set :group, "webapp"
set :use_sudo, false
set :bundle_flags, "--deployment --quiet --binstubs"

set :default_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

# repository
set :scm, :git
set :repository,  "git@github.com:ericsoderberg/pbc3.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1

# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :setup_solr_data_dir do
    run "mkdir -p #{shared_path}/solr/#{rails_env}"
    run "mkdir -p #{shared_path}/solr/pids"
    run "ln -nfs #{shared_path}/solr/#{rails_env} #{release_path}/solr/#{rails_env}"
    run "ln -nfs #{shared_path}/solr/pids #{release_path}/solr/pids"
  end
end

# http://www.hackido.com/2010/03/capistrano-sunspot-in-rails.html
##task :before_update_code do
##  stop solr:
##  run "cd #{current_path} && rake sunspot:solr:stop RAILS_ENV=production"
##end

after 'deploy:update_code', 'deploy:migrate'

#after "deploy:update_crontab", "deploy:solr:symlink"

namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:start" #sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/#{rails_env}/data --pid-dir=#{shared_path}/pids/#{rails_env}"
  end
  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:stop" #sunspot-solr stop --port=8983 --data-directory=#{shared_path}/solr/#{rails_env}/data --pid-dir=#{shared_path}/pids/#{rails_env}"
  end
  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/production/data"
    start
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end
end

after 'deploy:update_code', 'deploy:setup_solr_data_dir'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
