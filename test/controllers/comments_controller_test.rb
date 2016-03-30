require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  
  include Devise::TestHelpers
  
  test "should create a comment" do 
    sign_in users(:me)
    assert_difference('Comment.count') do 
      post :create, comment: { :content => "This is a comment" }, thought_id: thoughts(:one)
    end
    assert_response :redirect
    assert_redirected_to thought_path( thoughts(:one) )
  end
  
  test "should delete a comment" do 
    sign_in users(:me)
    assert_difference('Comment.count', -1) do 
      delete :destroy, id: comments(:one), thought_id: thoughts(:one)
    end
    assert_response :redirect
    assert_redirected_to thought_path( thoughts(:one) )
  end
  
end
