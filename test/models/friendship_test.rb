require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  test "will only save with both user and friend id's present" do 
    @friendship = users(:me).friendships.build
    assert_not @friendship.save
  end
  
  test "a friendship is unique" do 
    @friendship_one = friendships(:one)
    @friendship_two = friendships(:duplicate)
    @friendship_one.save
    assert_not @friendship_two.save
  end

  test "a user should not be friends with themselves" do 
    @friendship = Friendship.new(:user_id => 1, :friend_id => 1)
    assert_not @friendship.save
  end
end
