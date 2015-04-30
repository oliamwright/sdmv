
namespace :deploy do

	desc "deploy the precompiled assets"
	task :deploy_assets, :except => { :no_release => true } do
		run_locally("RAILS_ENV=development bundle exec rake assets:clean && RAILS_ENV=development bundle exec rake assets:precompile")
		run_locally("tar -czvf public/assets.tgz public/assets")
		top.upload("public/assets.tgz", "#{release_path}/public/", { :via => :scp, :recursive => true })
		run "cd #{release_path} && tar -zxvf public/assets.tgz 1> /dev/null"
		run_locally("rm -rf public/assets")
		run_locally("rm public/assets.tgz")
	end

end

before 'deploy:start', 'deploy:deploy_assets'
before 'deploy:restart', 'deploy:deploy_assets'

