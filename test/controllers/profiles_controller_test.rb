require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get show if user signed in" do
    sign_in users(:me)
    get 'show', id: users(:me).id
    assert_response :success
    assert_template 'show'
    assert_template layout: 'layouts/application'
  end
  
  test "should not get show if user isnt signed in" do
    get 'show', id: users(:me).id
    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end

end
