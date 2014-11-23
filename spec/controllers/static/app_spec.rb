# coding: utf-8
require 'spec_helper'

RSpec.describe Static::Api, type: :controller do
  include Rack::Test::Methods

  def app
    @app ||= Static::Api.new
  end

  describe "GET /rooms/:id", autodoc: true do
    before {
      @room_id = "test"
    }
    it "should be ok" do
      get "/rooms/#{@room_id}"
      expect(last_response).to be_ok
      room = Room.new @room_id
      expect(room.members.length).to be > 0
      room.destroy_all!
    end
  end

end