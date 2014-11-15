# encoding: utf-8
require "i18n" unless defined?(I18n)

I18n.enforce_available_locales = false
I18n.default_locale = :ja
I18n.locale = :ja

I18n.load_path += Dir["#{APP_CONFIG["root"]}/config/locales/*.yml"]
I18n.backend.load_translations