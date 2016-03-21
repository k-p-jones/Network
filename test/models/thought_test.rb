require 'test_helper'

class ThoughtTest < ActiveSupport::TestCase
  test 'it does not save when content is empty' do 
    @thought = users(:one).thoughts.build
    assert_not @thought.save
  end
  
  test 'it saves when content is not empty' do 
     @thought = users(:two).thoughts.build(:content => "Hello World")
     assert @thought.save
  end
  
  test 'the users id is saved to the thought' do 
    @thought = users(:two).thoughts.build(:content => "Hello World")
    @thought.save
    assert @thought.user_id == users(:two).id
  end
  
  test 'the thought comments are empty on creation' do 
    @thought = users(:two).thoughts.build(:content => "Hello World")
    assert @thought.comments.count == 0
  end
end
