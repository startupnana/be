require 'test_helper'

class MpsynthesizerControllerTest < ActionController::TestCase

  test "face_fp works" do
   face_picture_test 'synthesize', :face_fp => true
  end

  test "We can process faces pictures images" do
    face_picture_test 'synthesize'
    face_picture_test 'makeover', :mkovrmodel => 'lib/assets/mpsynth/makeover/titan.mko'
    face_picture_test 'makeover_synthesize', :mkovrmodel => 'lib/assets/mpsynth/makeover/titan.mko'
  end

  test "Can get synthesizer featurepoints" do
    face_picture_test 'feature_points'
  end

  test "Incorrect parameter does trigger an error" do
    wrong_parameter_test 'synthesize'
    wrong_parameter_test 'makeover', :mkovrmodel => 'lib/assets/mpsynth/makeover/titan.mko'
    wrong_parameter_test 'makeover_synthesize', :mkovrmodel => 'lib/assets/mpsynth/makeover/titan.mko'
  end


  test "Can detect mpsynth errorrs" do
    mpsynth_error 'synthesize'
    mpsynth_error 'makeover', :mkovrmodel => 'lib/assets/mpsynth/makeover/titan.mko'
    mpsynth_error 'makeover_synthesize', :mkovrmodel => 'lib/assets/mpsynth/makeover/titan.mko'
  end


  test "Unrecognized faces" do
    unrecognized_face 'synthesize'
    unrecognized_face 'makeover', :mkovrmodel => 'lib/assets/mpsynth/makeover/titan.mko'
    unrecognized_face 'makeover_synthesize', :mkovrmodel => 'lib/assets/mpsynth/makeover/titan.mko'
 end


  test "Authentification works" do
    assert_response 401, get("ping")
    setup_auth_failure!
    assert_response 401, get("ping")
    setup_auth_success!
    assert_response :success,  get("ping")
    assert get("ping").body == "pong"
  end


  test "mpsynth allowed only for authenticated users" do
    setup_auth_failure!
    assert_response 401, post("synthesize")
    assert_response 401, post("makeover", :mkovrmodel => 'lib/assets/mpsynth/makeover/titan.mko')
    assert_response 401, post("makeover_synthesize", :mkovrmodel => 'lib/assets/mpsynth/makeover/titan.mko')
  end
end
