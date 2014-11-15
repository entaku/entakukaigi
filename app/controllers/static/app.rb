# encoding: utf-8
module Static
  class Api < StaticBase

    get "/" do
      render_html "pages/home"
    end

    get "/rooms/:id" do
      uuid = UUID.new
      @room_id = params[:id]
      @user_id = uuid.generate
      $redis.sadd room_key(@room_id), @user_id
      render_html "rooms/show"
    end

    post "/api/rooms_users/:id" do
      content_type HTTPHelper::CONTENT_TYPE_JSON
      members = $redis.smembers(room_key(params[:id]))
      halt MultiJson.dump(members)
    end

    delete "/api/rooms_users/:id" do
      # content_type HTTPHelper::CONTENT_TYPE_JSON
      $redis.srem(room_key(params[:id]), params[:user_id])
      halt ""
    end

    private

      def room_key(room_id)
        "rooms:#{room_id}"
      end

  end
end
