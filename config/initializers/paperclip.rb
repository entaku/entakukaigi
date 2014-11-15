# # encoding: utf-8
# if %w(production staging).include?(ENV['RACK_ENV'])
#   S3_CONF = {
#     access_key_id: APP_CONFIG["access_key_id"],
#     secret_access_key: APP_CONFIG["secret_access_key"],
#     bucket: APP_CONFIG["bucket"]
#   }
# end

# Paperclip.interpolates :user_id do |attachment, style|
#   if attachment.instance.user_id.nil?
#     "default"
#   else
#     attachment.instance.user_id
#   end
# end
# Paperclip.interpolates :token  do |attachment, style|
#   attachment.instance.token
# end
# Paperclip.options[:command_path] = "/usr/bin"
# # Paperclip.options[:image_magick_path] = "/usr/bin/convert"
# Paperclip.options[:log] = ENV['RACK_ENV'] == "development"
# Paperclip.options[:log_command] = ENV['RACK_ENV'] == "development"
