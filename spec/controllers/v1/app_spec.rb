require 'spec_helper'

RSpec.describe Static::Api, type: :controller do
  include Rack::Test::Methods

  def app
    @app ||= V1::Api.new
  end

end