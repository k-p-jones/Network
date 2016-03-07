require 'test_helper'

class ThoughtsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
