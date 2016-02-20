
# bundler bootstrap
require 'bundler/capistrano'

set :application, "pbc3.1"

#!!!
# role :web, "www.pbc.org"                          # Your HTTP server, Apache/etc
# role :app, "www.pbc.org"                          # This may be the same as your `Web` server
# role :db,  "www.pbc.org", :primary => true # This is where Rails migrations will run
role :web, "test.pbc.org"                          # Your HTTP server, Apache/etc
role :app, "test.pbc.org"                          # This may be the same as your `Web` server
role :db,  "test.pbc.org", :primary => true # This is where Rails migrations will run

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
set :branch, "pbc4" #!!!
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
end

after 'deploy:update_code', 'deploy:migrate'
