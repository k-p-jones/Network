require 'test_helper'
require 'capybara/rails'

class UserFlowsTest < ActionDispatch::IntegrationTest
  
  def login_user
    @david = User.create(first_name: "David", last_name: "Smith", email: "david@mail.com", password: Devise::Encryptor.digest(User, "helloworld"))
    visit '/'
    fill_in "Email", with: @david.email
    fill_in "Password", with: @david.password
    click_button('Log in')
    assert page.has_content?('Signed in successfully.')
  end
  
  test "user logs in and browses site then signs out" do 
   login_user
   click_link "Connect"
   assert page.has_content?("#{users(:amy).first_name}")
   click_link "Profile"
   assert page.has_content?("#{@david.first_name}'s Thoughts")
   click_link "Feed"
   assert page.has_css?('#feed_loop')
   click_link "Sign Out"
   assert_equal current_path, user_session_path
  end
  
  test "user logs in and creates a new thought from the feed page" do 
    login_user
    visit '/'
    fill_in "thought[content]", with: "Hello World! This is a thought"
    click_button "post"
    within '#feed_loop' do 
        assert page.has_content?("Hello World! This is a thought")
    end
  end
  
  #Profiles page currently redirects to feed when posting a thought. Must fix
  
  test "user logs in and posts a thought from their profile page" do 
    login_user
    click_link "Profile"
    fill_in "thought[content]", with: "Hello Everyone!"
    click_button "post"
    within "#profile_thoughts_loop" do 
        assert page.has_content?("Hello Everyone!")
    end
  end
  
end
