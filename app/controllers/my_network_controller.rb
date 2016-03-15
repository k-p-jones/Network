class MyNetworkController < ApplicationController
    def show
        @friends = current_user.friendships.pluck(:friend_id)
        @friends_inv = current_user.inverse_friendships.pluck(:user_id)
        @the_ids = []
        @the_ids << @friends
        @the_ids << @friends_inv
        @the_ids.flatten
        @user = current_user
        @users = User.where.not(:id => @the_ids)
        @pending = current_user.friends
        @requests = current_user.inverse_friends
        @friends = []
        @friends << current_user.friendships 
        @friends << current_user.inverse_friendships
        @my_friends = @friends.flatten
    end
end
