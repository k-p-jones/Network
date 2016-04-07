require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
    
  include Devise::TestHelpers
  
  test "should create a friendship" do 
    sign_in users(:pugsley)  
    assert_difference('Friendship.count') do 
        @request.env['HTTP_REFERER'] = '/my_network/show'
        post :create, friendship: { :friend_id => 7 }, friend_id: 7 #second argument to post is the params you want to send to the controller
    end
    assert_redirected_to '/my_network/show'
  end 
  
  test "should destroy friendship" do 
      sign_in users(:me)
      assert_difference('Friendship.count', -1) do
        @request.env['HTTP_REFERER'] = '/my_network/show' 
        delete :destroy, id: friendships(:one)
      end
      assert_redirected_to '/my_network/show'
  end
  
  test "should update the friendship" do 
    sign_in users(:me)
    @request.env['HTTP_REFERER'] = '/my_network/show'
    patch :update, id: friendships(:four), friendship: {:accepted => true}
    assert_response :redirect
    assert_redirected_to '/my_network/show'
  end
end
