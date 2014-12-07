# encoding: utf-8
module Static
  class Api < StaticBase

    get "/" do
      @rooms = Room.open
      render_html "pages/home", layout: :home
    end

    get "/rooms/:id.?:format?" do
      reject_bot!
      # user = User.new
      room = Room.new params[:id]
      @room_id = room.id
      # @user_id = user.id
      # room.add! @user_id
      render_html "rooms/show"
    end

    private

      def reject_bot!
        bot? && redirect(static_path("root"))
      end

      def bot?
        env["HTTP_USER_AGENT"] && env["HTTP_USER_AGENT"].match(/bot|spider|crawler|facebook|google|twitter|baidu/i)
      end

  end
end
