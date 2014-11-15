# # encoding: utf-8
# file_path = if RUBY_PLATFORM == "java"
#   'config/database-jruby.yml'
# else
#   'config/database.yml'
# end
# db_config = YAML::load_file(file_path)[ENV['RACK_ENV']]
# ActiveRecord::Base.establish_connection db_config

# Time.zone = ActiveSupport::TimeZone.new 'Tokyo'
# # ActiveRecord::Base.time_zone_aware_attributes = true
# ActiveRecord::Base.default_timezone = :local
