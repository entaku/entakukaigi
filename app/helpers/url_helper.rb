# encoding: utf-8
module URLHelper

  def static_url(key, options = nil)
    full_url static_path(key, options)
  end

  def static_path(key, options = nil)
    options ? STATIC_PATH.get(key) % options : STATIC_PATH.get(key)
  end

  # def api_url(key, options = nil)
  #   full_url api_path(key, options)
  # end

  # def api_path(key, options = nil)
  #   options ? API_PATH.get(key) % options : API_PATH.get(key)
  # end

  # def admin_url(key, options = nil)
  #   full_url admin_path(key, options)
  # end

  # def admin_path(key, options = nil)
  #   options ? ADMIN_PATH.get(key) % options : ADMIN_PATH.get(key)
  # end

  private

    def full_url(path)
      "#{site_url}#{path}"
    end

    def site_url
      "#{APP_CONFIG["protocol"]}://#{APP_CONFIG["host"]}"
    end

end