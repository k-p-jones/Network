require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  
  def login_user
    get user_session_path
    assert_equal 200, status
    @david = User.create(first_name: "David", last_name: "Smith", email: "david@mail.com", password: Devise::Encryptor.digest(User, "helloworld"))
    post user_session_path, 'user[email]' => @david.email, 'user[password]' =>  @david.password
    follow_redirect!
  end
  
  test "user logs in and browses site then signs out" do 
    login_user
    assert_template 'thoughts/index'
    get_via_redirect(my_network_show_path)
    assert_template 'my_network/show'
    get_via_redirect(profiles_show_path(:id => @david.id))
    assert_template 'profiles/show'
    get_via_redirect(root_path)
    assert_template 'thoughts/index'
  end
   
end
