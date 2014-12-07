# encoding: utf-8
module AppHelper

  ENCODER = MultiJson
  MSGPACK_ENCODER = ::MessagePack

  def set_content_type
    content_type get_content_type
  end

  def authenticate_user!
    render_errors([t(:unauthenticated, scope: 'devise.failure')], 401) if current_user.nil?
  end

  def authenticate_guest!
    render_errors([t(:authenticated, scope: 'devise.failure')], 401) if current_user
  end

  def authenticate_admin!
    render_errors([t(:authenticated, scope: 'devise.failure')], 401) if current_admin.nil?
  end

  def render_ok
    set_content_type
    halt encoder.dump("")
  end

  def render_model_errors(ar_model)
    status 422
    message = { "errors" => ar_model.errors.full_messages }
    set_content_type
    halt encoder.dump(message)
  end

  def render_errors(messages, status_code = 422)
    status status_code
    data = { "errors" => messages }
    set_content_type
    halt encoder.dump(data)
  end

  def handle_data(data)
    set_content_type
    halt encoder.dump(data)
  end

  def render!(view_path)
    params[:format] == "msgpack" ? render_msgpack(view_path) : render_json(view_path)
  end

  def render_json(view_path)
    content_type HTTPHelper::CONTENT_TYPE_JSON
    rabl :"#{view_path}", format: "json"
  end

  def render_msgpack(view_path)
    content_type HTTPHelper::CONTENT_TYPE_MSGPACK
    rabl :"#{view_path}", format: "msgpack"
  end

  def rabl(template, options = {}, locals = {})
    Rabl.register!
    render :rabl, template, options, locals
  end

  def t(*args)
    I18n.t(*args)
  end

  private

    def get_content_type
      params[:format] == "msgpack" ? HTTPHelper::CONTENT_TYPE_MSGPACK : HTTPHelper::CONTENT_TYPE_JSON
    end

    def encoder
      params[:format] == "msgpack" ? MSGPACK_ENCODER : ENCODER
    end

end
