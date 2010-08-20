set :stages, %w(staging sandbox production)
set :default_stage, 'staging'

require 'capistrano/ext/multistage'

set :application, 'pelorus'

set :scm, :git
set :repository, 'git@toolforchange.com:pelorus.git'
set :deploy_via, :remote_cache

set :user, 'deploy'
set :ssh_options, { :forward_agent => true }
set :use_sudo, false

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

role :app, 'toolforchange.com'
role :web, 'toolforchange.com'
role :db,  'toolforchange.com', :primary => true

namespace :deploy do
  desc 'restarting mod_rails with restart.txt'
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |task|
    desc "#{task} task is a no-op with passenger"
    task task, :roles => :app do
      # no-op
    end
  end
end

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end