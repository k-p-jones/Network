require 'test_helper'

class MyNetworkControllerTest < ActionController::TestCase
  
  include Devise::TestHelpers
  
  
  test "should not get show page if user isnt signed in" do 
    get 'show'
    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end
  
  test "should get show page if user signed in" do 
    sign_in users(:me)
    get 'show'
    assert_response :success
    assert_template 'show'
    assert_template layout: 'layouts/application'
  end
end
