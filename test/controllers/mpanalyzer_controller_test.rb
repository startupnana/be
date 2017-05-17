require 'test_helper'

class MpanalyzerControllerTest < ActionController::TestCase

  test "We can process faces pictures images" do
    file = Rack::Test::UploadedFile.new(SuccessTestImage, "image/jpeg")
    setup_auth_success!
    assert_response :success, post("analyze", :file => file, :format => :json)
    assert Dir["#{Config.mpsynth.tmp_dir}/*"].length == 0
  end

  test "feature points works" do
    file = Rack::Test::UploadedFile.new(SuccessTestImage, "image/jpeg")
    setup_auth_success!
    response = post(:analyze, :file => file, :format => :json)
    json_response =  JSON.parse(response.body)
    assert json_response["feature_points"]["FP_BASICPARTS_EYE_LEFT"]["x"] > 0
    assert Dir["#{Config.mpsynth.tmp_dir}/*"].length == 0
  end


  test "Unrecognized faces does trigger errors" do
    file = Rack::Test::UploadedFile.new(FailTestImage, "image/jpeg")
    setup_auth_success!
    response = post("analyze", :file => file)
    assert_response :unprocessable_entity, response
    assert JSON.parse(response.body)["error"]["code"] == ApplicationController::ErrorCode::FaceRecognitionFailed, "Expected error code #{ApplicationController::ErrorCode::FaceRecognitionFailed}, reponse was: #{response.body}"
    assert Dir["#{Config.mpsynth.tmp_dir}/*"].length == 0
  end


  test "Authentification works" do
    assert_response 401, get("ping")
    setup_auth_failure!
    assert_response 401, get("ping")
    setup_auth_success!
    assert_response :success, get("ping")
    assert get("ping").body == "pong"
  end


  test "synthesize allowed only for authenticated users" do
    setup_auth_failure!
    assert_response 401, post("analyze")
  end
end
