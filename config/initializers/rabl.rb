# encoding: utf-8
# ActiveSupport::Cache.lookup_store :redis_store

# if %w(production).include?(ENV['RACK_ENV'])
#   redis_option = {
#     path:   APP_CONFIG["redis"]["path"],
#     namespace: "cache",
#     driver:    :hiredis
#   }
# else
#   redis_option = {
#     host:      APP_CONFIG["redis"]["host"],
#     port:      APP_CONFIG["redis"]["port"],
#     namespace: "cache",
#     driver:    :hiredis
#   }
# end
# Rabl.configure do |config|
#   if RUBY_PLATFORM == "java"
#     # config.view_paths = [Rails.root.join("app/views")]
#     config.cache_engine = ActiveSupport::Cache::RedisStore.new redis_option
#     config.perform_caching = true
#     config.cache_sources = ENV['RACK_ENV'] != 'development'
#     config.include_json_root = false
#     config.include_msgpack_root = false
#     config.include_child_root = false
#     config.msgpack_engine = ::MessagePack
#   else
#     config.json_engine = ::Oj
#   end
# end