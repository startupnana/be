require 'test_helper'

class UsersControllerTest  < ActionController::TestCase
  test "Can create user" do
    setup_auth_success!
    response = post("create", :username => "AnUserName", :password => "APassword", :format =>:json)
    puts response.body
    assert_response :success, response
  end

  test "Override same name user" do
    setup_auth_success!
    assert_response :success, post("create", :username => "AnUserName", :password => "APassword", :format =>:json)
    assert_no_difference 'User.count' do
      assert post("create", :username => "AnUserName", :password => "APassword", :format =>:json).success? == true
    end
  end

  test "Cannot create a bad user" do
    setup_auth_success!
    assert_no_difference 'User.count' do
      assert post("create", :username => "AnoUserName", :format =>:json).success? == false
    end
  end

  test "Cannot create an user if not authenticated" do
    setup_auth_failure!
    assert_no_difference 'User.count' do
      assert_response 401 , post("create", :username => "AnUserName", :password => "APassword", :format =>:json)
    end
  end
end
