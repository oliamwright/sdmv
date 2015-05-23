# unicorn_rails -c config/unicorn.rb -E production -D

rails_env = # rubocop:disable Lint/UselessAssignment
  ENV['RAILS_ENV'] || 'production'

worker_processes 2

preload_app true

timeout 30

socket_path = '/var/www/trueinteraction.com/shared/sockets/unicorn.sock'
pid_path = '/var/www/trueinteraction.com/shared/pids/unicorn.pid'
app_root = '/var/www/trueinteraction.com/current'

listen socket_path, backlog: 2048
pid pid_path

Dir.chdir(Unicorn::HttpServer::START_CTX[:cwd] = app_root)

stderr_path app_root + '/log/unicorn.stderr.log'
stdout_path app_root + '/log/unicorn.stdout.log'

before_fork do |server, _worker|
  old_pid = app_root + '/tmp/pids/unicorn.pid.oldbin'
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      `echo "unicorn rescue" > /tmp/unicorn.log`
    end
  end
end

after_fork do |_server, worker|
  ActiveRecord::Base.establish_connection

  begin
    uid = Process.euid
    gid = Process.egid
    user = 'deploy'
    group = 'deploy'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
    raise e
  end
end
