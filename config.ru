ENV['RACK_ENV'] ||= "development"
require 'rubygems'
require 'bundler'

# raise "Ruby 2.0.0 or later is required " if RUBY_VERSION.to_i < 2

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

if RUBY_PLATFORM != "java" && %w(staging production).include?(ENV['RACK_ENV'])
  if ENV['PUMA'].nil?
    require 'gctools/oobgc'
    if defined?(Unicorn::HttpRequest)
      use GC::OOB::UnicornMiddleware
    end
  end
end

require './config/boot.rb'

if ENV['RACK_ENV'] == "development"
  use Rack::Static,
    urls: ["/fonts", "/images", "/goml", "/base", "/ckeditor"],
    root: "public"
end

if ENV['RACK_ENV'] == "development"
  map '/assets' do
    run Static::Api.sprockets
  end
end

map '/api/v1' do
  run Api::V1.new
end

map '/' do
  run Static::Api.new
end