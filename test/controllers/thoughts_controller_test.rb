require 'test_helper'

class ThoughtsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "User can sign in" do 
    sign_in users(:me)
    assert_response :success
  end
  
  test "should get index when signed in" do
    sign_in users(:me)
    get 'index'
    assert_response :success
    assert_template 'index'
    assert_template layout: 'layouts/application'
  end
  
  test "should redirect to sign in page if user has not logged in" do
    get 'index'
    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end
  
  test "should get new page if user signed in" do
    sign_in users(:me)
    get 'new'
    assert_response :success
    assert_template 'new'
    assert_template layout: 'layouts/application'
  end
  
  test "should not get new page if user isnt signed in" do 
    get 'new'
    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end
  
  test "should get edit page if user signed in" do 
    sign_in users(:me)
    get 'edit', id: thoughts(:one).id
    assert_response :success
    assert_template 'edit'
    assert_template layout: 'layouts/application'
  end
  
  test "should not get the edit page if user isnt signed in" do 
    get 'edit', id: thoughts(:one).id
    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end
  
  test "should get the show page if a user is signed in" do 
    sign_in users(:me)
    get 'show', id: thoughts(:one).id
    assert_response :success
    assert_template 'show'
    assert_template layout: 'layouts/application'
  end
  
  test "should not get the show page if a user isn't signed in" do 
    get 'show', id: thoughts(:one).id
    assert_response :redirect
    assert_redirected_to '/users/sign_in'
  end 
  
  test "should create a Thought" do 
    sign_in users(:me)
    assert_difference('Thought.count') do 
      post :create, thought: { :content => "Hello World" }
    end
    assert_redirected_to '/'
  end
  
  test "should update the post" do
    @id = thoughts(:one).id
    sign_in users(:me)
    patch :update, id: @id, thought: { :content => "goodbye World"}
    assert_redirected_to thought_path(@id)
  end
  
  test "should destroy post" do 
    sign_in users(:me)
    assert_difference('Thought.count', -1) do 
      delete :destroy, id: thoughts(:one).id
    end
    assert_redirected_to '/'
  end
end
