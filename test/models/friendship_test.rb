require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  test "will only save with both user and friend id's present" do 
    @friendship = users(:one).friendships.build
    assert_not @friendship.save
  end
  
  test "a friendship is unique" do 
    @friendship_one = friendships(:one)
    @friendship_two = friendships(:two)
    @friendship_one.save
    assert_not @friendship_two.save
  end

  test "a user should not be friends with themselves" do 
    @friendship = friendships(:three)
    assert_not @friendship.save
  end
end
