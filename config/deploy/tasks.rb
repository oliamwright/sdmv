require 'bundler/capistrano'
load 'config/deploy/unicorn'
load 'config/deploy/local_assets'
#load 'config/deploy/delayed_job'

after 'deploy:finalize_update', 'deploy:migrate'
