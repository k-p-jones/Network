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
  
  test "confirmed_friends should include all friendships that are confirmed" do
    @user = users(:me)
    assert_includes @user.confirmed_friends, friendships(:one)
    assert_not_includes @user.confirmed_friends, friendships(:two)
  end
  
  test "confirmed_friends_ids should include the ids of confirmed friends only" do 
    @user = users(:me)
    @ids = @user.confirmed_friends_ids
    assert_includes @ids, friendships(:one).friend_id
    assert_includes @ids, friendships(:five).user_id
    assert_not_includes @ids, @user.id
    assert_not_includes @ids, friendships(:four).user_id
  end
  
  test "my_friends should contain the ids of all friends regarless of whether the friendship is confirmed" do
    @user = users(:me)
    @ids = @user.my_friends
    assert_includes @ids, friendships(:one).friend_id
    assert_includes @ids, friendships(:two).friend_id
    assert_not_includes @ids, friendships(:six)
  end
end
