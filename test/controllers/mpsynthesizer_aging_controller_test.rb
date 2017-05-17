
require 'test_helper'

class MpsynthesizerAgingControllerTest < ActionController::TestCase
  test "We can process faces pictures images" do
    response = face_picture_test 'aging', :skindir => 'lib/assets/mpsynth/aging', :mode => '3d'
    assert JSON.parse(response.body)
    response = face_picture_test 'aging', :skindir => 'lib/assets/mpsynth/aging', :mode => '2d'
    assert response.content_type.include?('image')
  end


  test "Incorrect parameter does trigger an error" do
    wrong_parameter_test 'aging', :skindir => 'lib/assets/mpsynth/aging', :mode => '3d'
    wrong_parameter_test 'aging', :skindir => 'lib/assets/mpsynth/aging', :mode => '2d'
  end


  test "Can detect mpsynth errors" do
    mpsynth_error 'aging', :skindir => 'lib/assets/mpsynth/aging', :mode => '3d'
    mpsynth_error 'aging', :skindir => 'lib/assets/mpsynth/aging', :mode => '2d'
  end


  test "Unrecognized faces" do
    unrecognized_face 'aging', :skindir => 'lib/assets/mpsynth/aging', :mode => '3d'
    unrecognized_face 'aging', :skindir => 'lib/assets/mpsynth/aging', :mode => '2d'
  end


  test "mpsynth allowed only for authenticated users" do
    setup_auth_failure!
    assert_response 401, post("aging", :mode => '3d')
    assert_response 401, post("aging", :mode => '2d')
  end
end
