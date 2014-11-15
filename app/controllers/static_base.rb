# encoding: utf-8
# require 'sinatra/namespace'
require "action_dispatch"
require "rack/csrf"
require "sinatra/flash"
require "sinatra/multi_route"
require "sinatra/namespace"

class StaticBase < SinatraBase
  register WillPaginate::Sinatra

  # helpers Kaminari::Helpers::SinatraHelpers

  register Sinatra::MultiRoute
  register Sinatra::Flash
  register Sinatra::Namespace
  # use Rack::Csrf, raise: true, skip: ["DELETE:/*"]

  enable :method_override

  configure :development do
    register Sinatra::Reloader
    also_reload "./app/models/*"
    also_reload "./app/views/*"
    also_reload "./app/helpers/*"
    also_reload "./app/controllers/static/*"
  end

  configure :development, :test do
    set :sprockets, Sprockets::Environment.new(root)
    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix = '/assets'
      config.digest = true
      config.debug = true unless ENV['PROD']
      sprockets.append_path '../assets/vendor'
      sprockets.append_path '../assets/javascripts'
      sprockets.append_path '../assets/templates'
      sprockets.append_path '../assets/stylesheets'
      sprockets.append_path '../assets/images'
      sprockets.append_path '../assets/fonts'
      helpers Sprockets::Helpers
    end
  end

  helpers BaseHelper
  helpers StaticHelper
  # helpers PaginateHelper
  helpers URLHelper

  def render_errors(errors)
    render_html "errors/503"
  end

  error do
    status 503
    render_html "errors/503"
  end

  not_found do
    status 404
    render_html "errors/404"
  end

end
