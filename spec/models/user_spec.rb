require 'spec_helper'

RSpec.describe User, type: :model do
  context "initialize" do
    it {
      user = User.new
      expect(user.id).not_to be_empty
    }
  end
end
