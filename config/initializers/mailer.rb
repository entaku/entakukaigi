# # encoding: utf-8
# ActionMailer::Base.view_paths = "#{APP_CONFIG["root"]}/app/views"

# if %w(development).include?(ENV["RACK_ENV"])
#   ActionMailer::Base.add_delivery_method :letter_opener,
#     LetterOpener::DeliveryMethod,
#     location: File.expand_path('../../../tmp/letter_opener', __FILE__)
#   ActionMailer::Base.delivery_method = :letter_opener
# elsif %w(test).include?(ENV["RACK_ENV"])
#   ActionMailer::Base.delivery_method = :test
# else
#   ActionMailer::Base.delivery_method = :smtp
#   ActionMailer::Base.smtp_settings = { enable_starttls_auto: false }
# end

# ActionMailer::Base.logger = LOGGER
