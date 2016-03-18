class ProfilesController < ApplicationController
  
  def show
    # Gather the ID's of all friends
    @friends = current_user.friendships.pluck(:friend_id)
    @friends_inv = current_user.inverse_friendships.pluck(:user_id)
    @the_ids = []
    @the_ids << @friends
    @the_ids << @friends_inv
    @friend_ids = @the_ids.flatten
    # Find a given users profile and thoughts
    @user = User.find_by_id(params[:id])
    @thoughts = @user.thoughts.order('created_at DESC')
    # Create thought from your own profile
    @thought = current_user.thoughts.build
  end

end
