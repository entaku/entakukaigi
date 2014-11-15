# encoding: utf-8
module StaticHelper

  if %w(staging production).include?(ENV["RACK_ENV"])

    def stylesheet_tag(file, option = {})
      filename = "#{file}.css"
      media = option[:media] ? option[:media] : "all"
      turbolinks = option[:turbolinks] ? "data-turbolinks-track" : ""
      %Q(<link rel="stylesheet" href="/assets/#{ASSETS_PATH[filename]}" media="#{media}" #{turbolinks}>)
    end

    def javascript_tag(file, option = {})
      filename = "#{file}.js"
      defer = option[:defer] ? "defer" : ""
      async = option[:async] ? "async" : ""
      turbolinks = option[:turbolinks] ? "data-turbolinks-track" : ""
      %Q(<script src="/assets/#{ASSETS_PATH[filename]}" #{defer} #{async} #{turbolinks}></script>)
    end

  end

  def set_content_type
    content_type HTTPHelper::CONTENT_TYPE_TEXT
  end

  def render_html(view_path)
    erb :"#{view_path}.html", format: "html"
  end

  def t(*args)
    I18n.t(*args)
  end

  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end

  def styled_flash(key=:flash)
    return "" if flash(key).empty?
    id = (key == :flash ? "flash" : "flash_#{key}")
    type = ""
    messages = flash(key).collect { |message|
      "  <div class='flash #{message[0]}'>#{message[1]}</div>\n"
    }
    "<div id='#{id}' class='alert alert-info'>\n" + messages.join + "</div>"
  end

end
