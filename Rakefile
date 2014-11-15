ENV['RACK_ENV'] ||= "development"
ENV['RACK_ENV'] ||= "t"
require 'rubygems'
require 'bundler'
Bundler.require(:default, :test, :assets, :development, :rake, ENV['RACK_ENV'].to_sym, :migration, :raketask)
require 'sinatra/base'
require 'sinatra/activerecord'
# require 'sinatra/contrib'
begin
  require './config/boot.rb'
rescue => e
end

require 'fileutils'
task default: :spec
require "foreigner"
desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec)
# DB_CONFIG = YAML.load_file('config/database.yml')[ENV['RACK_ENV']]
# Foreigner.load

require "sinatra/activerecord/rake"

# Make sure all your models are loaded.

desc 'erd'
task :erd do
  require "rails_erd/diagram/graphviz"
  RailsERD::Diagram::Graphviz.create \
    filetype: "pdf",
    attributes: ["foreign_keys", "primary_keys", "timestamps", "inheritance", "content"],
    polymorphism: true,
    inheritance: true,
    indirect: true
end
# require "fileutils"
# Bundler.require(:assets, :development)
BUILD_DIR = Pathname.new "./public/assets"
DIGEST = false


namespace :assets do
  desc "compile assets"
  task :compile do
    sprockets = StaticBase.sprockets
    sprockets.js_compressor  = :uglify
    sprockets.css_compressor = :scss
    if defined? MANIFEST_PATH
      path = MANIFEST_PATH
    else
      path = "./public/assets/manifest.json"
    end
    manifest = Sprockets::Manifest.new(sprockets, path)
    manifest.compile(["application.js", "application.css"])
  end
end