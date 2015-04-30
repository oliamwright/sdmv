
namespace :unicorn do
	desc "restart unicorn"
	task :restart, :roles => :app do
		run "cd #{deploy_to}/current; [ -f tmp/pids/unicorn.pid ] && sudo kill -USR2 `cat tmp/pids/unicorn.pid` || sudo /usr/local/bin/bundle exec unicorn_rails -c config/unicorn-#{application}.rb -E production -D"
	end

	desc "start unicorn"
	task :start, :roles => :app do
		run "cd #{deploy_to}/current; [ -f tmp/pids/unicorn.pid ] || sudo /usr/local/bin/bundle exec unicorn_rails -c config/unicorn-#{application}.rb -E production -D"
	end

	desc "stop unicorn"
	task :stop, :roles => :app do
		run "cd #{deploy_to}/current; [ -f tmp/pids/unicorn.pid ] && sudo kill -QUIT `cat tmp/pids/unicorn.pid`"
	end

	desc "symlink_unicorn_config"
	task :symlink_unicorn_config, :roles => :app do
		run "cd #{release_path}/config; [ -f unicorn-#{application}.rb ] || ln -s unicorn.rb unicorn-#{application}.rb"
	end

end

after 'deploy:start', 'unicorn:start'
after 'deploy:restart', 'unicorn:restart'
before 'deploy:stop', 'unicorn:stop'

after 'deploy:finalize_update', 'unicorn:symlink_unicorn_config'

