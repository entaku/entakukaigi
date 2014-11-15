source 'https://rubygems.org'

## WAF
gem 'sinatra', require: false

## rails
rails_version = '~> 4.1.7'
gem 'activerecord', rails_version, require: 'active_record'#, github: 'rails/rails'
gem 'activesupport', rails_version, require: ['active_support/core_ext', 'active_support/inflector']
# gem 'actionmailer', rails_version, require: 'action_mailer'
gem 'actionpack', rails_version, require: false

# gem 'active_model_serializers', require: false
# gem 'postgres_ext-serializers', require: 'postgres_ext/serializers'
## authentication
# gem 'bcrypt'

## cache
gem 'hiredis'
gem 'redis', require: ['redis/connection/hiredis', 'redis']
gem 'redis-store', require: false
gem 'redis-activesupport', require: false

gem 'uuid'
# image
# gem 'paperclip', '~> 4.2.0'
# gem 'paperclip-rack', require: 'paperclip/rack'

## logging
# gem 'fluent-logger', require: false, path: 'lib/fluent'

# gem 'awesome_nested_set', '~> 3.0.0'
# gem 'acts_as_list'

# gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.1'

gem 'rack_csrf', require: false
gem 'sinatra-flash', require: false
# gem 'sinatra-partial', require: false
gem 'sinatra-contrib', require: false
gem 'sinatra-formhelpers', require: false


# database
platform :ruby do
  ## database
  group :development, :staging, :production do
    # gem 'mysql2'
    # gem 'pg'
  end
  group :test do
    gem 'sqlite3'
  end
end
platform :jruby do
  ## database
  # gem 'activerecord-jdbc-adapter'
  # gem 'jdbc-postgres'
  gem 'activerecord-jdbcpostgresql-adapter'
  group :development, :test do
    gem 'activerecord-jdbcsqlite3-adapter'
  end
end

## JSON and API
gem 'oj', platforms: :ruby
gem 'yajl-ruby', require: 'yajl', platforms: :ruby
gem 'multi_json'

# Serialize object
gem 'msgpack', platforms: :ruby
gem 'msgpack-jruby', require: 'msgpack', platforms: :jruby

gem 'rake', require: false

# provides a high performance replacement to String#blank?
gem 'fast_blank', platforms: :ruby
# gem 'aws-sdk'

gem 'i18n'

gem 'foreigner', require: false

## views
gem 'rabl'#, require: false#, '~> 0.8.6'

gem 'will_paginate', require: ['will_paginate', 'will_paginate/active_record']
# gem 'airbrake', '3.1.14', require: false

platform :ruby do
  ## server
  group :development, :test do
    gem 'thin', '~> 1.6.0', require: false, platforms: :ruby
  end
  group :production, :staging do
    gem 'unicorn', require: false, platforms: :ruby
    gem 'gctools', require: false
  end
end
# platform :jruby do
#   ## server
#   # bundle exec rackup config.ru -s Puma -e $RACK_ENV -b unix:///var/run/puma.sock
#   gem 'puma'
# end
group :production, :staging do
  gem 'puma', require: false
end

### GROUPS ####
group :development, :test do
  gem 'rspec'
  gem 'rspec-core', require: ['rspec/core', 'rspec/core/rake_task']
  gem 'racksh'

  gem 'codesake-dawn', require: false, platforms: :ruby
  gem 'annotate'#, github: 'SamSaffron/annotate_models'

  gem 'byebug', platforms: :ruby

  gem 'sprockets'
  gem 'sprockets-helpers'
  gem 'htmlcompressor', require: false
  gem 'bullet'
end

group :development, :test do
  gem 'spring'
  # gem 'rack-cors', require: 'rack/cors', platforms: :ruby
  # manage multiple processes
  gem 'foreman', require: false # foreman start
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'

  gem 'ar2gostruct', require: false
  gem 'sinatra-activerecord', require: "sinatra/activerecord/rake"
  gem 'rails-erd', require: false

  gem 'letter_opener'

  gem 'yui-compressor'

  gem 'sass'
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
  # Use CoffeeScript for .js.coffee assets and views
  gem 'therubyracer', platforms: :ruby
  gem 'therubyrhino', platforms: :jruby
  gem 'coffee-script'
  gem 'compass'
  gem 'sprockets-sass'
  gem 'eco'
  gem 'eco_compress'
  gem 'ejs'

  gem 'thor'
end

group :test do
  gem 'minitest'
  gem 'shoulda'
  # add matchers from shoulda
  gem 'shoulda-matchers'

  gem 'mocha'

  gem 'capybara'
  gem 'poltergeist', require: 'capybara/poltergeist'

  # gem 'rb-fsevent',
  #   require: RUBY_PLATFORM =~ /darwin/i ? 'rb-fsevent' : false
  # gem 'rb-inotify', '~> 0.9',
  #   require: RUBY_PLATFORM =~ /linux/i ? 'rb-inotify' : false

  gem 'guard-rspec'
  gem 'spork', '~> 1.0.0rc4'
  gem 'guard-spork', platforms: :ruby

  # code coverage for tests
  gem 'simplecov', require: false

  # Removes records from database created during tests
  gem 'database_cleaner'

  gem 'autodoc'#, github: "shin1ohno/autodoc", branch: "rspec3"

  gem 'faker'
  # Manipulate Time.now in specs
  gem 'timecop'
  gem 'factory_girl'
  gem 'vcr'
  gem 'webmock'
end
