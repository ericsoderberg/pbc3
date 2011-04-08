# RVM bootstrap
$:.unshift(File.expand_path("~/.rvm/lib"))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.2-p180'

# bundler bootstrap
require 'bundler/capistrano'

set :application, "pbc3"

role :web, "66.84.18.94"                          # Your HTTP server, Apache/etc
role :app, "66.84.18.94"                          # This may be the same as your `Web` server
role :db,  "66.84.18.94", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

#server
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "/srv/rails/#{application}"
set :user, "webapp3"
set :group, "webapp"
set :use_sudo, false

# repository
set :scm, :git
set :repository,  "git@github.com:ericsoderberg/pbc3.git"
set :deploy_via, :remote_cache
set :branch, "master"
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

  #desc "Symlink shared resources on each release - not used"
  #task :symlink_shared, :roles => :app do
  #  #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  #end
end

#after 'deploy:update_code', 'deploy:symlink_shared'

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