root = "/opt/sinatra/mitemite"

threads 8,32
workers 4 if RUBY_PLATFORM != "java"
preload_app!
pidfile "#{root}/tmp/puma.pid"
state_path "#{root}/tmp/state"
bind 'unix:///tmp/puma.sock'

on_worker_boot do
  if defined?(ActiveSupport) && defined?(ActiveRecord) && defined?(ActiveRecord::Base)
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.establish_connection if ActiveRecord::Base.respond_to? :establish_connection
    end
  end
end