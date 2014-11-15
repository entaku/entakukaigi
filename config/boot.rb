require "./config/setup"

require "sinatra/base"
require "will_paginate/view_helpers/sinatra"

class MsgPackSerializer < Rack::Session::Cookie::Base64

  ENCODER = RUBY_PLATFORM == "java" ? ::JSON : ::Oj

  def encode(str)
    super(::MessagePack.dump(str))
  end

  def decode(str)
    return unless str
    ::MessagePack.load(super(str)) rescue nil
  end
end

class SinatraBase < Sinatra::Base
  disable :protection
  use Rack::Protection::IPSpoofing
  use Rack::Protection::PathTraversal
  use Rack::Protection::JsonCsrf

  set :environment, ENV['RACK_ENV'].to_sym
  set :traps, false
  disable :run

  # use ActiveRecord::QueryCache

  configure do
    set :views, "./app/views"
    disable :logging
    LOGGER.instance_eval { alias :write :'info' unless respond_to?(:write) }
    use Rack::CommonLogger, LOGGER
  end

  configure :development do
    require "bullet"
    Bullet.enable = true
    Bullet.console = true
    Bullet.bullet_logger = true
    use Bullet::Rack
    set :reload_templates, true
  end

  configure :development, :test do
    set :static, true
  end

  use Rack::Session::Cookie,
    expire_after: 60*60*24*14,
    path: '/',
    http_only: true,
    key: "entaku.session",
    # secure: ENV['RACK_ENV'] == "production",
    secret: "5999d3322139862ee8656ba798e4d0c25fb89f1832753e69cbdd9da4a63189285a0d0e2b499416f1f280204179d74831b7v1f9a68aafa28c96a966a8c910f97e",
    coder: MsgPackSerializer.new

  before do
    set_content_type
    # if !ActiveRecord::Base.connection.active?
    #   ActiveRecord::Base.clear_active_connections!
    #   render_errors(["An error occured. Please retry."]) if !ActiveRecord::Base.connection.active?
    # end
    LOGGER.debug params
  end

end

[
  "initializers/before",
  "initializers",
  "../lib/utils",
  "../app/services",
  "../app/models",
  "../app/helpers",
  "../app/controllers",
  "../app/controllers/static",
  "initializers/after"
].each do |m|
  Dir[File.expand_path("../#{m}/*.rb", __FILE__)].each do |file|
    require file
  end
end