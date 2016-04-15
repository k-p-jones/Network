require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  
  test "should save with valid user_id" do 
    @thought = thoughts(:one)
    @thought.likes.build(:user_id => users(:me).id)
    assert @thought.save
  end
  
  test "should not save with invalid user id" do 
    @thought = thoughts(:one)
    @thought.likes.build(:user_id => "")
    assert_not @thought.save
  end
  
  test "like should be unique" do 
    @thought = thoughts(:one)
    @thought.likes.build(:user_id => users(:me).id)
    @thought.save
    @thought.likes.build(:user_id => users(:me).id)
    assert_not @thought.save
  end
  
  test "like should belong to a user" do 
    @thought = thoughts(:one)
    @thought.likes.build(:user_id => users(:me).id)
    assert @thought.likes.first.user_id == users(:me).id
  end 
  
  test "like should belong to a thought" do 
    @thought = thoughts(:one)
    @like = @thought.likes.build(:user_id => users(:me).id)
    assert @like.thought_id == thoughts(:one).id
  end
end
