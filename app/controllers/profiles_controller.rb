class ProfilesController < ApplicationController
  
  def show
    @friends = current_user.friendships.pluck(:friend_id)
    @friends_inv = current_user.inverse_friendships.pluck(:user_id)
    @the_ids = []
    @the_ids << @friends
    @the_ids << @friends_inv
    @friend_ids = @the_ids.flatten
    @user = User.find_by_id(params[:id])
    @thoughts = @user.thoughts.order('created_at DESC')
    @thought = current_user.thoughts.build
  end

end
