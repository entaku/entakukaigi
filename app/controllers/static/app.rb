# encoding: utf-8
module Static
  class Api < StaticBase

    get "/" do
      render_html "pages/home"
    end

    get "/rooms/:id.?:format?" do
      user = User.new
      room = Room.new params[:id]
      @room_id = room.id
      @user_id = user.id
      room.add! @user_id
      render_html "rooms/show"
    end

    post "/api/rooms_users/:id.?:format?" do
      content_type HTTPHelper::CONTENT_TYPE_JSON
      room = Room.new params[:id]
      halt MultiJson.dump(room)
    end

    delete "/api/rooms_users/:id.?:format?" do
      room = Room.new params[:id]
      room.destroy! params[:user_id]
      halt ""
    end

  end
end
