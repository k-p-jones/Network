require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
 
 test "test presence of site links" do
    login_user
    get '/'
    assert_template 'thoughts/index'
    assert_template layout: 'layouts/application'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", my_network_show_path
    assert_select "a[href=?]", destroy_user_session_path
    assert_select "a[href=?]", profiles_show_path(:id => @david.id)
  end
  
   #log in a devise user
   def login_user
    get user_session_path
    assert_equal 200, status
    @david = User.create(first_name: "David", last_name: "Smith", email: "david@mail.com", password: Devise::Encryptor.digest(User, "helloworld"))
    post user_session_path, 'user[email]' => @david.email, 'user[password]' =>  @david.password
    follow_redirect!
   end
 
end
