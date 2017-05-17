require 'test_helper'

class CardDetectionControllerTest < ActionController::TestCase

  test "We can process a face picture without a card" do
    file = Rack::Test::UploadedFile.new(SuccessTestImage, "image/jpeg")
    setup_auth_success!
    assert_response :success, post("detect", :file => file, :format => :json)
  end
end
