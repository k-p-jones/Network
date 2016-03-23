require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "Shoud not save user without email and password" do 
    @user = User.new
    assert_not @user.save
  end
  
  test "pending_requests should output all friendships that are unconfirmed" do
    @user = users(:me)
    assert_includes @user.pending_requests, friendships(:two)
    assert_not_includes @user.pending_requests, friendships(:one)
  end
  
  test "recieved_requests should output all inverse_friendships that are unconfirmed" do
    @user = users(:me)
    assert_includes @user.recieved_requests, friendships(:four)
    assert_not_includes @user.recieved_requests, friendships(:five)
  end
end
