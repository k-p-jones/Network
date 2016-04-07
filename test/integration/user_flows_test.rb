require 'test_helper'
require 'capybara/rails'

class UserFlowsTest < ActionDispatch::IntegrationTest
  self.use_transactional_fixtures = false 

  setup do 
    @david = User.create(first_name: "David", last_name: "Smith", email: "david@mail.com", password: Devise::Encryptor.digest(User, "helloworld"))
    @steve = User.create(first_name: "Steve", last_name: "Smith", email: "steve@mail.com", password: Devise::Encryptor.digest(User, "hellopassword"))
  end
  
  def login_david
    visit '/'
    fill_in "Email", with: @david.email
    fill_in "Password", with: @david.password
    click_button('Log in')
  end

  def login_steve
    visit '/'
    fill_in "Email", with: @steve.email
    fill_in "Password", with: @steve.password
    click_button('Log in')
  end

  def setup_steve_thought
    login_steve
    visit '/'
    fill_in "thought[content]", with: "This is Steve's thought!"
    click_button "post"
    click_link "Sign Out"
  end

  def setup_david_thought
    login_david
    visit '/'
    fill_in "thought[content]", with: "This is Dave's thought!"
    click_button "post"
    click_link "Sign Out"
  end

  def setup_friendship
    login_david
    click_link "Connect"
    page.all(:link, "Add Friend")[8].click
    click_link "Sign Out"
    login_steve
    click_link "Connect"
    click_button "Accept"
    click_link "Sign Out"
  end


  
  test "user logs in and browses site then signs out" do
   Capybara.use_default_driver  
   login_david
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
    Capybara.use_default_driver 
    login_david
    visit '/'
    fill_in "thought[content]", with: "Hello World! This is a thought"
    click_button "post"
    within '#feed_loop' do 
        assert page.has_content?("Hello World! This is a thought")
    end
  end
  
  
  test "user logs in and posts a thought from their profile page" do 
    Capybara.use_default_driver 
    login_david
    click_link "Profile"
    fill_in "thought[content]", with: "Hello Everyone!"
    click_button "post"
    within "#profile_thoughts_loop" do 
        assert page.has_content?("Hello Everyone!")
    end
  end
  
  test "user  posts then deletes a thought from the profile page" do
    Capybara.current_driver = :selenium
    login_david
    click_link "Profile"
    fill_in "thought[content]", with: "Hello Everyone!"
    click_button "post"
    within "#profile_thoughts_loop" do 
        assert page.has_content?("Hello Everyone!")
        click_link "Destroy"
        page.accept_alert
        assert_not page.has_content?("Hello Everyone!")
    end  
  end

  test "user logs in and makes a post from the feed page and deletes it" do 
    Capybara.current_driver = :selenium
    login_steve
    fill_in "thought[content]", with: "Hey Everyone"
    click_button "post"
    within "#feed_loop" do 
      assert page.has_content?("Hey Everyone")
      click_link "Destroy"
      page.accept_alert
      assert_not page.has_content?("Hey Everyone")
    end
  end

  test "user friendship is sent and accepted, can then see friends thoughts" do 
    Capybara.use_default_driver
    setup_steve_thought
    login_david
    click_link "Connect"
    page.all(:link, "Add Friend")[8].click
    click_link "Sign Out"
    login_steve
    click_link "Connect"
    click_button "Accept"
    click_link "Sign Out"
    login_david
    assert page.has_content?("This is Steve's thought!")
  end

  test "user comment's on a friends post" do 
    Capybara.use_default_driver
    setup_steve_thought
    setup_friendship
    login_david
    assert page.has_content?("This is Steve's thought!")
    within "#feed_loop" do 
      within ".thought_wrapper" do 
        first(".thought_button").click
      end
    end
    fill_in "comment[content]", with: "Hi Steve"
    click_button "Comment"
    assert page.has_content?("Hi Steve")
    within ".comment_counter > p" do 
      assert page.has_content?("1")
    end
  end

  test "user deletes their own comment" do 
    Capybara.current_driver = :selenium
    setup_steve_thought
    setup_friendship
    login_david
    assert page.has_content?("This is Steve's thought!")
    within "#feed_loop" do 
      within ".thought_wrapper" do 
        first(".thought_button").click
      end
    end
    fill_in "comment[content]", with: "Hi Steve"
    click_button "Comment"
    assert page.has_content?("Hi Steve")
    within ".comment_counter > p" do 
      assert page.has_content?("1")
    end
    within("#comments_loop") do 
      assert page.has_content?("Hi Steve")
      click_link "Delete"
    end
    sleep(1)
    assert_not page.has_content?("Hi Steve")
    within ".comment_counter > p" do 
      assert page.has_content?("0")
    end
  end

  test "user deletes someone else's comment on their thought" do 
    Capybara.current_driver = :selenium
    setup_steve_thought
    setup_friendship
    login_david
    assert page.has_content?("This is Steve's thought!")
    within "#feed_loop" do 
      within ".thought_wrapper" do 
        first(".thought_button").click
      end
    end
    fill_in "comment[content]", with: "Hi Steve"
    click_button "Comment"
    assert page.has_content?("Hi Steve")
    within ".comment_counter > p" do 
      assert page.has_content?("1")
    end
    click_link "Sign Out"
    login_steve
    within "#feed_loop" do 
      within ".thought_wrapper" do 
        first(".thought_button").click
      end
    end
    within("#comments_loop") do 
      assert page.find(".the_comment_content")
      assert page.has_content?("Hi Steve")
      click_link "Delete"
      sleep(1)
      assert_not page.has_content?("Hi Steve")
    end
    within ".comment_counter > p" do 
      assert page.has_content?("0")
    end  
  end

  test "user deletes a friendship, can no longer see their thoughts" do 
    Capybara.use_default_driver
    setup_david_thought
    setup_friendship
    login_steve
    click_link "Connect"
    within("#confirmed_friends") do 
      click_link "Unfriend"
    end
    within("#users_list") do 
      assert page.has_content?("David Smith")
    end
    click_link "Feed"
    within("#feed_loop") do 
      assert_not page.has_content?("This is Dave's thought!")
    end
  end

end
