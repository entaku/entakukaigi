ENV['RACK_ENV'] ||= "development"

require 'yaml'
unless defined? APP_CONFIG
  APP_CONFIG = YAML.load_file('config/app_config.yml')[ENV['RACK_ENV']]
end
unicorn_conf = YAML.load_file('config/unicorn.yml')[ENV['RACK_ENV']]

worker_processes unicorn_conf["worker_processes"]

working_directory unicorn_conf["working_directory"]

listen unicorn_conf["listen"], backlog: 64
# listen unicorn_conf["port"], tcp_nopush: true

timeout 15

pid unicorn_conf["pid"]

stderr_path File.expand_path('log/unicorn-stderr.log', unicorn_conf["working_directory"])
stdout_path File.expand_path('log/unicorn-stdout.log', unicorn_conf["working_directory"])

preload_app true

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

# check_client_connection false

before_fork do |server, worker|
  # defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  if defined?(ActiveRecord) && defined?(ActiveRecord::Base) && defined?(ActiveRecord::Base.connection)
    begin
      ActiveRecord::Base.connection.disconnect!
    rescue => e
    end
  end

  old_pid = "#{ server.config[:pid] }.oldbin"
  unless old_pid == server.pid
    begin
      Process.kill :QUIT, File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  GC.disable
  if defined?(ActiveRecord) && defined?(ActiveRecord::Base)
    begin
      ActiveRecord::Base.establish_connection
    rescue => e
    end
  end
  # defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end