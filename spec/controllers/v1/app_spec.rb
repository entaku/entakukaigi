require 'spec_helper'

RSpec.describe Static::Api, type: :controller do
  include Rack::Test::Methods

  def app
    @app ||= Static::Api.new
  end

  describe "POST /api/rooms_users/:id", autodoc: true do
    before {
      @room_id = "test"
      @user = User.new
    }
    it "should be ok" do
      room = Room.new @room_id
      room.destroy_all!
      room.add! @user.id
      post "/api/rooms_users/#{@room_id}"
      expect(last_response).to be_ok
      result = MultiJson.load last_response.body
      expect(result).to include(@user.id)
      room.destroy_all!
    end
  end

  describe "DELETE /api/rooms_users/:id", autodoc: true do
    before {
      @room_id = "test"
      @user = User.new
    }
    it "should be ok" do
      room = Room.new @room_id
      room.destroy_all!
      room.add! @user.id
      option = {
        user_id: @user.id
      }
      delete "/api/rooms_users/#{@room_id}", option
      expect(last_response).to be_ok
      expect(room.members).to be_empty
    end
  end

end