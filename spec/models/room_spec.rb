require 'spec_helper'

RSpec.describe Room, type: :model do
  before(:each) {
    @room = Room.new "foobar"
  }

  after(:each) {
    $redis.del "rooms:foobar"
  }

  it {
    expect(@room.id).not_to be_empty
    user_id = "johnsmith"
    @room.add! user_id
    expect(@room.members).to eq([user_id])
    expect(MultiJson.dump(@room)).to eq(MultiJson.dump(@room.members))
    @room.destroy! user_id
    expect(@room.members).to eq([])
  }

end