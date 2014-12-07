require 'spec_helper'

RSpec.describe Api::V1, type: :controller do
  include Rack::Test::Methods

  def app
    @app ||= Api::V1.new
  end

  context "GET /rooms/:id", autodoc: true do
    before(:each) {
      @room_id = "test"
      $redis.keys("rooms:*").each { |key| $redis.del key }
    }
    it "should be ok" do
      room = Room.new @room_id
      room.destroy_all!

      get "/rooms/#{@room_id}"
      expect(last_response).to be_ok
      expect(room.members.length).to be > 0
      result = MultiJson.load last_response.body
      user_id = result["user_id"]

      get "/rooms/#{@room_id}/users", {user_id: user_id}
      expect(last_response).to be_ok
      result = MultiJson.load last_response.body
      expect(result).to include(user_id)

      delete "/rooms/#{@room_id}/users/#{user_id}"
      expect(last_response).to be_ok
      expect(room.members.length).to be == 0
      room.destroy_all!
    end
  end

end