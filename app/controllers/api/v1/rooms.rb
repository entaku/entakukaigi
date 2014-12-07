# encoding: utf-8
module Api
  class V1 < ApiBase

    # enter room
    get "/rooms/:id.?:format?" do
      user = User.new
      room = Room.new params[:id]
      @room_id = room.id
      @user_id = user.id
      room.add! @user_id
      data = { :user_id => user.id }
      handle_data data
    end

    # rooms member list
    get "/rooms/:id/users.?:format?" do
      room = Room.new params[:id]
      if room.is_member?(params[:user_id])
        handle_data room.members
      else
        render_errors(["not authorized"])
      end
    end

    # delete user from room
    delete "/rooms/:id/users/:user_id.?:format?" do
      room = Room.new params[:id]
      room.destroy! params[:user_id]
      render_ok
    end

  end
end