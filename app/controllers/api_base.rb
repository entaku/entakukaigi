# encoding: utf-8
class ApiBase < SinatraBase

  configure :development do
    register Sinatra::Reloader
    also_reload "./app/models/*"
    also_reload "./app/views/*"
    also_reload "./app/helpers/*"
    also_reload "./app/controllers/*"
    also_reload "./app/controllers/api/v1/*"
  end

  # Rabl.configure do |config|
  #   config.view_paths = ["./app/views"]
  #   config.cache_sources = true
  #   redis_option = {
  #     host:      APP_CONFIG["redis"]["host"],
  #     port:      APP_CONFIG["redis"]["port"],
  #     namespace: "cache",
  #     driver:    :hiredis
  #   }
  #   config.cache_engine = ActiveSupport::Cache::RedisStore.new redis_option
  #   config.perform_caching = true
  # end
  # Rabl.register!
  # set :rabl, format: :json

  helpers BaseHelper
  helpers AppHelper

  before { set_content_type }

  error do
    status 503
    messages = ["503"]
    data = { "errors" => messages }
    handle_data(data)
  end

  not_found do
    status 404
    messages = ["404"]
    data = { "errors" => messages }
    handle_data(data)
  end

end
