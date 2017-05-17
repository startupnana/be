ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  SuccessTestImage = "test/fixtures/success.jpg"
  FailTestImage= "test/fixtures/fail.jpg"
  NotAnImage = "API.md"


  def setup_auth_success!
    user = HTTPAuthUsers.sample
    @request.headers["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user['user']}:#{user['password']}")
  end


  def setup_auth_failure!
    @request.headers["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("not_an_user_name:not_a_password")
  end


  def face_picture_test path, extra_arg = {}
    file = Rack::Test::UploadedFile.new(SuccessTestImage, "image/jpeg")
    setup_auth_success!
    params = {:file => file}
    params.merge!(extra_arg)
    response = post(path, params)
    assert_response :success, post(path, params)
    assert Dir["#{Config.mpsynth.tmp_dir}/*"].length == 0, "Should leave work directory empty"
    response
  end


  def wrong_parameter_test path, extra_arg = {}
    file = Rack::Test::UploadedFile.new(FailTestImage, "image/jpeg")
    setup_auth_success!
    params = {:file => file, :format => 'JPEG'}
    params.merge!(extra_arg)
    response = post(path, params)
    assert_response :unprocessable_entity, response
    assert JSON.parse(response.body)["error"]["code"] == ApplicationController::ErrorCode::InvalidParameter
    response
  end


  def mpsynth_error path, extra_arg = {}
    file = Rack::Test::UploadedFile.new(NotAnImage, "image/jpeg")
    setup_auth_success!
    params = {:file => file}
    params.merge!(extra_arg)
    response = post(path, params)
    assert_response :unprocessable_entity, response
    assert JSON.parse(response.body)["error"]["code"] == ApplicationController::ErrorCode::UnknowError
    response
  end


  def unrecognized_face path, extra_arg = {}
    file = Rack::Test::UploadedFile.new(FailTestImage, "image/jpeg")
    setup_auth_success!
    params = {:file => file}
    params.merge!(extra_arg)
    response = post(path, params)
    assert_response :unprocessable_entity, response
    assert JSON.parse(response.body)["error"]["code"] == ApplicationController::ErrorCode::FaceRecognitionFailed
    assert Dir["#{Config.mpsynth.tmp_dir}/*"].length == 0, "Should leave work directory empty"
    response
  end
end
