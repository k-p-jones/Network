class MyNetworkController < ApplicationController
    def show
        @user = current_user
        @users = User.all
        @pending = current_user.friends
        @requests = current_user.inverse_friends
        @friends = []
        @friends << current_user.friendships 
        @friends << current_user.inverse_friendships
        @my_friends = @friends.flatten
    end
end
