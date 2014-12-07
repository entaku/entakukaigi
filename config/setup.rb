ENV['RACK_ENV'] ||= "development"
require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require "./lib/reloader" if %w(development).include?(ENV['RACK_ENV'])
# require "./lib/fluent-ex-logger"
require 'logger'


unless defined? APP_CONFIG
  APP_CONFIG = YAML.load_file('config/app_config.yml')[ENV['RACK_ENV']]
  APP_CONFIG.freeze
end

log_dir = "log"
Dir.mkdir(log_dir) unless File.exist?(log_dir)

if %w(development).include?(ENV['RACK_ENV'])
  log_level = Logger::DEBUG
  LOGGER = Logger.new("#{log_dir}/#{ENV['RACK_ENV']}.log", "weekly")
else
  log_level = Logger::ERROR
  LOGGER = Logger.new("#{log_dir}/#{ENV['RACK_ENV']}.log", "weekly")
end
LOGGER.level = log_level

# ActiveRecord::Base.logger = LOGGER
# ActiveRecord::Base.logger.level = Logger::INFO
$redis = if ENV["REDISTOGO_URL"] != nil
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Redis.new \
    host:     uri.host,
    port:     uri.port,
    password: uri.password,
    driver:   :hiredis
else
  Redis.new \
    host:   APP_CONFIG["redis"]["host"],
    port:   APP_CONFIG["redis"]["port"],
    driver: :hiredis
end