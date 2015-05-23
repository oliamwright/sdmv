set :application, 'true_interaction3'
set :repository, "git@swifthorse.trueinteraction.com:#{application}"

set :deploy_to, '/var/www/trueinteraction.com'

set :scm, :git
set :branch, 'master'

set :scm_username, 'git'
set :user, 'deploy'

role :web, 'deploy.trueinteraction.com'
role :app, 'deploy.trueinteraction.com'
role :db, 'deploy.trueinteraction.com', primary: true

set :keep_releases, 10
set :use_sudo, false

set :rails_env, 'production'

load 'config/deploy/tasks'

after 'deploy', 'deploy:cleanup'
