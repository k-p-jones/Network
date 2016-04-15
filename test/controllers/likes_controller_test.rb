require 'test_helper'

class LikesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should create a like" do 
  	@thought = thoughts(:one)
  	sign_in users(:me)
  	assert_difference('Like.count') do 
  		@request.env['HTTP_REFERER'] = '/'
  		post :create, like: {:user_id => users(:me).id, :thought_id => @thought.id}
  	end
  	assert_response :redirect
  	assert_redirected_to '/'
  end

  test "should destroy a like" do 
  	@thought = thoughts(:one)
  	@like = thoughts(:one).likes.build(:user_id => users(:me).id)
  	@like.save
  	sign_in users(:me)
  	assert_difference('Like.count', -1) do 
  		@request.env['HTTP_REFERER'] = '/'
  		delete :destroy, id: @like.id
  	end
  	assert_response :redirect
  	assert_redirected_to '/'
  end
end
