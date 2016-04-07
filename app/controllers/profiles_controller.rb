class ProfilesController < ApplicationController
  
  before_action :authenticate_user!
  
  def show
    @friend_ids = current_user.my_friends
    @user = User.find_by_id(params[:id])
    @thoughts = @user.thoughts.order('created_at DESC')
    @thought = current_user.thoughts.build
    @pending = current_user.friendships.where('friend_id= ?', @user.id)
    @recieved = current_user.inverse_friendships.where('user_id= ?', @user.id)
    @confirmed = current_user.confirmed_profile_friendship(@user.id, current_user)
  end
end
