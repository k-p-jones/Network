require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  test "should not save without content" do 
    @thought = thoughts(:one)
    @comment = users(:me).comments.build(:thought_id => @thought.id)
    assert_not @comment.save
  end
  
  test "should save with content" do 
    @thought = thoughts(:one)
    @comment = users(:me).comments.build(:thought_id => @thought.id, :content => "This is a comment")
    assert @comment.save
  end
  
  test "comment should belong to a thought" do 
    @thought = thoughts(:one)
    @comment = users(:me).comments.build(:thought_id => @thought.id, :content => "This is a comment")
    assert @thought.id == @comment.thought_id
  end
end
